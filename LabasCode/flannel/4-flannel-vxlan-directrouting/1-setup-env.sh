#!/bin/bash
set -v

# host version [22.04.3] https://fridge.ubuntu.com/2023/08/11/ubuntu-22-04-3-lts-released/
# dock version [23.0.1 ] https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/

# clab version [v0.59.0] https://github.com/srl-labs/containerlab/releases/download/v0.59.0/containerlab_0.59.0_linux_amd64.tar.gz
# vyos version [v1.4.9 ] docker pull burlyluo/vyos:1.4.9

# kind version [v0.20.0] https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-amd64
# imge version [v1.27.3] docker pull burlyluo/kindest:v1.27.3

# phub version [v2.7.1 ] docker pull docker.io/registry:2  
  # setup phub [docker run -d --network=host --restart=always --name phub registry:2]

# nettool imge [v1.1.11] docker pull burlyluo/nettool:latest
# iptables fwd [iptables -L | grep policy || and then: systemctl cat docker >> ExecStartPost=/sbin/iptables -P FORWARD ACCEPT]

# Auther name: [Wei Luo]
# Mail address [olaf.luo@foxmail.com]
# Docs address [https://www.yuque.com/wei.luo]
# Bootcamp url [https://youdianzhishi.com/web/course/1041]
# Issue report [https://github.com/BurlyLuo/wcni-kind/issues || https://gitee.com/rowan-wcni/wcni-kind/issues]


cat <<EOF
*****************************************************************
# lsb_release -a 
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy
*****************************************************************
# Lab topo:
            192.168.2.100/24   192.168.2.99/24 
                   |                 |
                 [phub]        [HOME_LAB_VM]
                   |                 |
                   |-------[win-x][Bridge Network]
                              192.168.2.11/24
                                     |
            192.168.2.10/24[Client]--|
*****************************************************************
# kind+clab topo:
                    172.18.0.4/16     172.18.0.5/16
                       worker1           worker2
                   KinD_Container3   KinD_Container4
                       server3          server4
                    10.1.8.10/24      10.1.8.11/24
                              \       /
                               \     /
           172.18.0.2/16        \   /         172.18.0.3/16
           control-plane         \ /             worker
          KinD_Container1----HOME_LAB_VM----KinD_Container2
              server1             |             server2
           10.1.5.10/24           |           10.1.5.11/24
                                 GWX
                                 /|\
                      10.1.5.1/24 | 10.1.8.1/24
                              MASQUERADE
                                  |
                    172.20.20.2/24->172.20.20.1/24
                                  |
                              MASQUERADE
                                  |
                  192.168.2.99/24->192.168.2.1/24->www
*****************************************************************
EOF

for tool in {wget,kind,kubectl,helm,docker,clab}; do
  if command -v $tool &> /dev/null; then
    echo $tool is already installed!
  else
    case $tool in
      wget)
        command -v yum &> /dev/null && yum -y install wget || command -v apt &> /dev/null && apt -y update && apt -y install wget || echo "pls install manually"
        ;;
      kind)
        wget https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-amd64 -O /usr/bin/kind && chmod +x /usr/bin/kind || exit 1
        ;;
      kubectl)
        wget https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl -O /usr/bin/kubectl && chmod +x /usr/bin/kubectl || exit 1
        ;;
      helm)
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash || exit 1
        ;;
      docker)
        echo "Strongly recommend Ubuntu or Debian distro|https://github.com/docker/docker-install"
        curl -fsSL https://get.docker.com | sh -s -- --version 23.0 && systemctl daemon-reload && systemctl restart docker && iptables -P FORWARD ACCEPT || exit 1
        ;;
      clab)
        bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.59.0 || exit 1
        ;;
      *)
        echo "Unknown tool, pls check the spelling." && exit 1
        ;;
    esac
  fi
done

phub=192.168.2.100
phub_passwd=hive
if ping -c 1 -W 1 "$phub" > /dev/null 2>&1; then
  sshpass -p $phub_passwd ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@$phub > /dev/null 2>&1
  curl -I http://$phub:5000/v2/ > /dev/null 2>&1 && echo "phub: $phub OK!" || ssh $phub "docker run -d --network=host --restart=always --name phub registry:2" || exit 1
else
  echo "Network unreachable: $phub"
fi

if [ "$(sysctl -n fs.inotify.max_user_watches)" != "524288" ]; then
  echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf
fi
if [ "$(sysctl -n fs.inotify.max_user_instances)" != "512" ]; then
  echo "fs.inotify.max_user_instances = 512" >> /etc/sysctl.conf 
fi
sysctl -p 2>/dev/null | grep "fs.inotify.max_user_"


# 1. Prepare NoCNI kubernetes environment
docker network list | grep -iw kind || docker network create --driver bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 --ipv6 --subnet=172:18:0:1::/64 kind || exit 1
cat <<EOF | KIND_EXPERIMENTAL_DOCKER_NETWORK=kind kind create cluster --name=flannel-vxlan-directrouting --image=burlyluo/kindest:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  podSubnet: "10.244.0.0/16"
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-ip: 10.1.5.10
        node-labels: "rack=rack0"

- role: worker
  kubeadmConfigPatches:
  - |
    kind: JoinConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-ip: 10.1.5.11
        node-labels: "rack=rack0"

- role: worker
  kubeadmConfigPatches:
  - |
    kind: JoinConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-ip: 10.1.8.10
        node-labels: "rack=rack1"

- role: worker
  kubeadmConfigPatches:
  - |
    kind: JoinConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-ip: 10.1.8.11
        node-labels: "rack=rack1"

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2. Remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

./2-setup-clab.sh

# 3. Collect startup message
controller_node_name=$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep control-plane)
if [ -n "$controller_node_name" ]; then
  timeout 1 docker exec -t $controller_node_name bash -c 'cat << EOF > /root/monitor_startup.sh
#!/bin/bash
ip -ts monitor all > /root/startup_monitor.txt 2>&1
EOF
chmod +x /root/monitor_startup.sh && /root/monitor_startup.sh'
else
  echo "No such controller_node!"
fi

# 4. Install CNI(flannel vxlan directrouting mode) [https://github.com/flannel-io/flannel#deploying-flannel-with-kubectl]
kubectl apply -f ./flannel.yaml

# 5. Wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 6. MTU issue
# https://github.com/BurlyLuo/wcni-kind/issues/2
# open 4-flannel-vxlan-directrouting-MTU-issue.cap
cat <<EOF
1	2025-09-03 06:59:41.644444	10.1.5.10	10.1.8.10	TCP	74	0x89ce (35278)	0	0	1	40106	10250	40106 → 10250 [SYN] Seq=0 Win=56760 Len=0 MSS=9460 SACK_PERM TSval=2057645512 TSecr=0 WS=128
2	2025-09-03 06:59:41.644497	10.1.8.10	10.1.5.10	TCP	74	0x0000 (0)	0	1	1	10250	40106	10250 → 40106 [SYN, ACK] Seq=0 Ack=1 Win=56688 Len=0 MSS=9460 SACK_PERM TSval=3947090888 TSecr=2057645512 WS=128
3	2025-09-03 06:59:41.644562	10.1.5.10	10.1.8.10	TCP	66	0x89cf (35279)	1	1	1	40106	10250	40106 → 10250 [ACK] Seq=1 Ack=1 Win=56832 Len=0 TSval=2057645512 TSecr=3947090888
4	2025-09-03 06:59:41.645096	10.1.5.10	10.1.8.10	TLSv1.3	320	0x89d0 (35280)	1	1	255	40106	10250	Client Hello
5	2025-09-03 06:59:41.645124	10.1.8.10	10.1.5.10	TCP	66	0x8aca (35530)	1	255	1	10250	40106	10250 → 40106 [ACK] Seq=1 Ack=255 Win=56448 Len=0 TSval=3947090889 TSecr=2057645513
6	2025-09-03 06:59:41.649443	10.1.8.10	10.1.5.10	TLSv1.3	2441	0x8acb (35531)	1	255	2376	10250	40106	Server Hello, Change Cipher Spec, Application Data, Application Data, Application Data, Application Data, Application Data
7	2025-09-03 06:59:41.857331	10.1.8.10	10.1.5.10	TCP	2441	0x8acc (35532)	1	255	2376	10250	40106	[TCP Retransmission] 10250 → 40106 [PSH, ACK] Seq=1 Ack=255 Win=56448 Len=2375 TSval=3947091101 TSecr=2057645513
8	2025-09-03 06:59:42.064884	10.1.8.10	10.1.5.10	TCP	2441	0x8acd (35533)	1	255	2376	10250	40106	[TCP Retransmission] 10250 → 40106 [PSH, ACK] Seq=1 Ack=255 Win=56448 Len=2375 TSval=3947091309 TSecr=2057645513
9	2025-09-03 06:59:42.473037	10.1.8.10	10.1.5.10	TCP	2441	0x8ace (35534)	1	255	2376	10250	40106	[TCP Retransmission] 10250 → 40106 [PSH, ACK] Seq=1 Ack=255 Win=56448 Len=2375 TSval=3947091717 TSecr=2057645513
10	2025-09-03 06:59:43.312991	10.1.8.10	10.1.5.10	TCP	2441	0x8acf (35535)	1	255	2376	10250	40106	[TCP Retransmission] 10250 → 40106 [PSH, ACK] Seq=1 Ack=255 Win=56448 Len=2375 TSval=3947092557 TSecr=2057645513
EOF

