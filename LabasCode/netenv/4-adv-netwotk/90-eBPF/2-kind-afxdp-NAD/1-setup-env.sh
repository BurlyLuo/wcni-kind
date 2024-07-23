#!/bin/bash
set -v
# 1.prep ebpf nad env
cat <<EOF | kind create cluster --name=afxdp-nad --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraMounts:
  - hostPath: /tmp/afxdp_dp/
    containerPath: /tmp/afxdp_dp/
    propagation: Bidirectional
    selinuxRelabel: false
- role: worker
  extraMounts:
  - hostPath: /tmp/afxdp_dp2/
    containerPath: /tmp/afxdp_dp/
    propagation: Bidirectional
    selinuxRelabel: false

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2.remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

