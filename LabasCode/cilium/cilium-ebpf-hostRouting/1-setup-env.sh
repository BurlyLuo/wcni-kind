#!/bin/bash
date
set -v

# 1.prep noCNI env[Ubuntu 22.04][https://docs.cilium.io/en/v1.14/installation/kind/#install-cilium]
cat <<EOF | kind create cluster --name=cilium-ebpf-host-routing --image=kindest/node:v1.27.3 --config=-
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
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3.install cni
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# kubeproxyreplacement Options(--set kubeProxyReplacement=strict)
# eBPF Host Routing(--set bpf.masquerade=true)
# https://docs.cilium.io/en/v1.14/network/kubernetes/kubeproxy-free/#kube-proxy-hybrid-modes
# The following Helm setup below would be equivalent to kubeProxyReplacement=true in a kube-proxy-free environment:
# helm install cilium cilium/cilium --version 1.14.0-rc.0 --namespace kube-system --set kubeProxyReplacement=false --set socketLB.enabled=true --set nodePort.enabled=true --set externalIPs.enabled=true --set hostPort.enabled=true --set k8sServiceHost=${API_SERVER_IP} --set k8sServicePort=${API_SERVER_PORT}
# https://docs.cilium.io/en/v1.14/operations/performance/tuning/#ebpf-host-routing

helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-ebpf-host-routing --set kubeProxyReplacement=strict --set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set bpf.masquerade=true 

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. cgroup v2 verify
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-ebpf-host-routing);do docker exec $container ls -al /proc/self/ns/cgroup;done

