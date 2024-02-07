#!/bin/bash
set -v
# 1. Prepare NoCNI kubernetes environment
cat <<EOF | kind create cluster --name=cilium-kubeproxy-vxlan --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  # kubeProxyMode: "none" # Enable KubeProxy
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
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Tunnel VxLAN Options(--set routingMode=tunnel --set tunnelProtocol=vxlan --set ipv4NativeRoutingCIDR="10.0.0.0/8")
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.15.0-rc.1 --namespace kube-system --set debug.enabled=true --set debug.verbose="datapath flow kvstore envoy policy" --set bpf.monitorAggregation=none --set monitor.enabled=true --set ipam.mode=cluster-pool --set cluster.name=cilium-kubeproxy-vxlan-vxlan --set routingMode=tunnel --set tunnelProtocol=vxlan --set ipv4NativeRoutingCIDR="10.0.0.0/8"

# 4. Wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. Cilium status(cilium status --verbose)
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. Separate namesapce and cgroup v2 verify [https://github.com/cilium/cilium/pull/16259 && https://docs.cilium.io/en/stable/installation/kind/#install-cilium]
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-kubeproxy-vxlan);do docker exec $container ls -al /proc/self/ns/cgroup;done
mount -l | grep cgroup && docker info | grep "Cgroup Version" | awk '$1=$1'

