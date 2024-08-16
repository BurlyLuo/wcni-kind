#!/bin/bash
set -v
# 1.prep noCNI env
cat <<EOF | kind create cluster --name=ipv4v6 --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        ipFamily: dual
        disableDefaultCNI: false
nodes:
        - role: control-plane
        - role: worker
        - role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."https://dockerproxy.com"]
    endpoint = ["https://dockerproxy.com"]
EOF

# 2.remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

