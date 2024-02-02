#!/bin/bash
set -v 

# 1.remove taints
controller_node_ip=`docker exec -it $(docker ps -a --format "table {{.Names}}" | grep control) ip a s eth0 | awk -F "inet " '{print $2}' | grep 172.18.0. | awk -F "/16" '{print $1}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 2.install cilium cni
helm repo add cilium https://helm.cilium.io/ > /dev/null 2>&1
help repo update > /dev/null 2>&1

# https://github.com/cilium/cilium/issues/23280
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set cluster.name=cilium-bgp --set tunnel=disabled --set ipam.mode=kubernetes --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set bgpControlPlane.enabled=true --set k8s.requireIPv4PodCIDR=true

# 3. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 4. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 5. cgroup v2 verify
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-bgp);do docker exec $container ls -al /proc/self/ns/cgroup;done

