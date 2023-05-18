#!/bin/bash
set -v
# exec &>./cluster1-install-log-rec.txt
date

# node info: 192.168.2.66

# create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster --name=cluster1 --image=192.168.2.100:5000/kindest/node:v1.23.4 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
        podSubnet: "10.10.0.0/16"
        serviceSubnet: "10.11.0.0/16"

nodes:
        - role: control-plane
        - role: worker


containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# prep the environment
controller_node=$(kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane)
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-
kubectl get nodes -owide 
kubectl get pods -owide -A

# install CNI
cilium install --context kind-cluster1 --version v1.12.0 --helm-set ipam.mode=kubernetes,cluster.name=cluster1,cluster.id=1
cilium status  --context kind-cluster1 --wait

