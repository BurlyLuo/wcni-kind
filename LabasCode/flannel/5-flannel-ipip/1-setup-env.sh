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
# KinD topo:
                            172.18.0.4/16
                               worker1
                           KinD_Container3
           172.18.0.2/16          |          172.18.0.3/16
           control-plane          |             worker
          KinD_Container1----HOME_LAB_VM----KinD_Container2
                            172.18.0.1/16
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
cat <<EOF | KIND_EXPERIMENTAL_DOCKER_NETWORK=kind kind create cluster --name=flannel-ipip --image=burlyluo/kindest:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  podSubnet: "10.244.0.0/16"
nodes:
  - role: control-plane
  - role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2. Remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

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

# 4. Install CNI(flannel ipip mode) [https://github.com/flannel-io/flannel#deploying-flannel-with-kubectl]
kubectl apply -f ./flannel.yaml
