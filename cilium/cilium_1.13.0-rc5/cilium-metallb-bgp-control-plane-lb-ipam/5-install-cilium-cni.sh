#!/bin/bash
set -v 

kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/master:NoSchedule-
kubectl get nodes -o wide

helm repo add cilium https://helm.cilium.io/ > /dev/null 2>&1
help repo update > /dev/null 2>&1

# [Do not set "--set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443" {kk describe ds/cilium to see the rc}]
helm install cilium cilium/cilium --version 1.13.0-rc5 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set cluster.name=clab-bgp-cplane --set tunnel=disabled --set ipam.mode=kubernetes --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set bgpControlPlane.enabled=true --set k8s.requireIPv4PodCIDR=true
