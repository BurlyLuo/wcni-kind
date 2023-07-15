#!/bin/bash
set -v
date

# 1. prep noCNI env
cat <<EOF | kind create cluster --name=cluster1 --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  podSubnet: "10.10.0.0/16"
  serviceSubnet: "10.11.0.0/16"

nodes:
  - role: control-plane
  - role: worker
  - role: worker
        
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2. remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. install CNI
cilium install --context kind-cluster1 --version 1.14.0-rc.0 --helm-set ipam.mode=kubernetes,cluster.name=cluster1,cluster.id=1
cilium status  --context kind-cluster1 --wait

