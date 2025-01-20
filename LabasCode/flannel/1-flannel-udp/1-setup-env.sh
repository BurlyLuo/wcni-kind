#!/bin/bash
set -v

# host version [22.04.3] https://fridge.ubuntu.com/2023/08/11/ubuntu-22-04-3-lts-released/
# dock version [23.0.1 ] https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/

# clab version [v0.59.0] https://github.com/srl-labs/containerlab/releases/download/v0.59.0/containerlab_0.59.0_linux_amd64.tar.gz
# vyos version [v1.4.9 ] docker pull burlyluo/vyos:1.4.9

# kind version [v0.20.0] https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-amd64
# imge version [v1.27.3] docker pull burlyluo/kindest:v1.27.3

# phub version [v2.7.1 ] docker pull docker.io/registry:2  
  # run p_hub: [docker run -d --network=host --restart=always --name phub registry:2]

# nettool imge [v1.1.11] docker pull burlyluo/nettool:latest
# iptables fwd [iptables -L | grep policy || and then: systemctl cat docker >> ExecStartPost=/sbin/iptables -P FORWARD ACCEPT]

# Auther name: [Wei Luo]
# Mail address [olaf.luo@foxmail.com]
# Docs address [https://www.yuque.com/wei.luo]
# Bootcamp url [https://youdianzhishi.com/web/course/1041]
# Issue report [https://github.com/BurlyLuo/wcni-kind/issues or https://gitee.com/rowan-wcni/wcni-kind/issues]


# 1. Prepare NoCNI environment:
cat <<EOF | kind create cluster --name=flannel-udp --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  podSubnet: "10.244.0.0/16"
nodes:
  - role: control-plane
    extraMounts:
    - hostPath: ./udp
      containerPath: /root/udp
    - hostPath: ./http-proxy.conf
      containerPath: /etc/systemd/system/containerd.service.d/http-proxy.conf
  - role: worker
    extraMounts:
    - hostPath: ./udp
      containerPath: /root/udp
    - hostPath: ./http-proxy.conf
      containerPath: /etc/systemd/system/containerd.service.d/http-proxy.conf

containerdConfigPatches:
  - |-
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
      endpoint = ["http://192.168.2.100:5000"]
EOF

# 2. Remove control-plane taints
controller_node_ip=$(kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}')
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

# 4. Install CNI(flannel udp mode) [https://github.com/flannel-io/flannel#deploying-flannel-with-kubectl]
kubectl apply -f ./flannel.yaml
