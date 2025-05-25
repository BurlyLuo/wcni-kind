#!/bin/bash
set -v 
# 1.Remove kubernetes node taints
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 2.Install Cilium[Cilium v1.15.17]
cilium_version=v1.15.17
docker pull quay.io/cilium/cilium:$cilium_version && docker pull quay.io/cilium/operator-generic:$cilium_version
kind load docker-image quay.io/cilium/cilium:$cilium_version quay.io/cilium/operator-generic:$cilium_version --name cilium-bgp
{ helm repo add cilium https://helm.cilium.io ; helm repo update; } > /dev/null 2>&1

# [Do not set "--set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443" {kk describe ds/cilium to see the rc}]
# Or
# controller_node_ip=`docker exec -it $(docker ps -a --format "table {{.Names}}" | grep control) ip a s eth0 | awk -F "inet " '{print $2}' | grep 172.18.0. | awk -F "/16" '{print $1}'`
# https://docs.cilium.io/en/stable/network/bgp-control-plane/#cilium-bgp-control-plane-beta
# BGP Control Plane provides a way for Cilium to advertise routes to connected routers by using the Border Gateway Protocol (BGP). BGP Control Plane makes Pod networks and/or Services of type LoadBalancer reachable from outside the cluster for environments that support BGP. Because BGP Control Plane does not program the datapath, do not use it to establish reachability within the cluster. (--set bgpControlPlane.enabled=true --set k8s.requireIPv4PodCIDR=true)
# --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443
controller_node_ip=`docker exec -it $(docker ps -a --format "table {{.Names}}" | grep control) ip a s eth0 | awk -F "inet " '{print $2}' | grep 172.18.0. | awk -F "/16" '{print $1}'`
# --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443

helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version v1.15.17 --namespace kube-system --set image.pullPolicy=IfNotPresent --set debug.enabled=true --set debug.verbose="datapath flow kvstore envoy policy" --set bpf.monitorAggregation=none --set monitor.enabled=true --set ipam.mode=kubernetes --set routingMode=native --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set bgpControlPlane.enabled=true --set k8s.requireIPv4PodCIDR=true

# 3. Wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 4. Cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 5. Sepretrate namesapce and cgroup v2 verify [https://github.com/cilium/cilium/pull/16259 && https://docs.cilium.io/en/stable/installation/kind/#install-cilium]
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-bgp);do docker exec $container ls -al /proc/self/ns/cgroup;done
mount -l | grep cgroup && docker info | grep "Cgroup Version" | awk '$1=$1'
