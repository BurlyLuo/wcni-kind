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


# 1. Prepare NoCNI environment
cat <<EOF | kind create cluster --name=cni-multus --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
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

# 3. Install CNI[Calico v3.23.2+multus]
kubectl apply -f ./k8snetworkplumbingwg

# 4. Wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
