#!/bin/bash
set -v
# 1. Prepare NoCNI kubernetes environment
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

# 2. Remove kubernetes node taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. Install CNI[Cilium 1.15.0-rc.1]
cilium_version=v1.15.0-rc.1
docker pull quay.io/cilium/cilium:$cilium_version && docker pull quay.io/cilium/operator-generic:$cilium_version
kind load docker-image quay.io/cilium/cilium:$cilium_version quay.io/cilium/operator-generic:$cilium_version --name cluster1

cilium install --context kind-cluster1 --version 1.15.0-rc.1 --helm-set ipam.mode=kubernetes,cluster.name=cluster1,cluster.id=1
cilium status  --context kind-cluster1 --wait

