#!/bin/bash
date
set -v

# 0.Notes
echo "
***************************************************************************************************************
$ kk logs ds/cilium | grep -i "BPF bandwidth manager"
Found 3 pods, using pod/cilium-v4ncj
level=info msg="  --enable-bandwidth-manager='true'" subsys=daemon
level=warning msg="BPF bandwidth manager could not read procfs. Disabling the feature." error="Failed to read /host/proc/sys/net/core/default_qdisc: open /host/proc/sys/net/core/default_qdisc: no such file or directory" subsys=bandwidth-manager
***************************************************************************************************************
due to this, vm based k8s is required!
"
# 1.prep noCNI env {VM[Ubuntu 20.04]}
# https://docs.cilium.io/en/latest/network/kubernetes/bandwidth-manager/#bandwidth-manager
# https://docs.cilium.io/en/latest/network/kubernetes/bandwidth-manager/#limitations
cat <<EOF | kind create cluster --name=cilium-bandwidth-manager --image=kindest/node:v1.23.4 --config=-
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

# 3.install cni
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# kubeproxyreplacement Options(--set kubeProxyReplacement=strict)
# eBPF Host Routing(--set bpf.masquerade=true)
# bandwidthManager(--set bandwidthManager.enabled=true)
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-bandwidth-manager --set kubeProxyReplacement=strict --set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set bpf.masquerade=true --set bandwidthManager.enabled=true 

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. cgroup v2 verify
for container in $(docker ps  -a --format "table {{.Names}}" | grep cilium-bandwidth-manager);do docker exec $container ls -al /proc/self/ns/cgroup;done

