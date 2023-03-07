#!/bin/bash
date
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=cilium-socket-lb --image=kindest/node:v1.23.4 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
        kubeProxyMode: "none"
nodes:
        - role: control-plane
        - role: worker
        - role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2.remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/master:NoSchedule-
kubectl get nodes -o wide


# 3. install CNI
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.13.0-rc5 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-socket-lb --set kubeProxyReplacement=strict --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set tunnel=disabled --set bpf.masquerade=true --set installNoConntrackIptablesRules=true --set socketLB.enabled=true

