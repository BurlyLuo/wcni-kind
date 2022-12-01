#!/bin/bash
set -v 

helm repo add cilium https://helm.cilium.io
helm template cilium cilium/cilium --set k8sServiceHost=192.168.2.71 --set k8sServicePort=6443  --version 1.12.0 --namespace kube-system --set kubeProxyReplacement=strict --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set bpf.masquerade=true --set ipam.mode=kubernetes --set tunnel=disabled --set loadBalancer.mode=dsr> ./cilium-dsr.yaml

kubectl apply -f ./cilium-dsr.yaml

kubectl create deploy dsr --image=192.168.2.100:5000/nettool
kubectl expose deployment dsr  --port=80 --target-port=80 --type=NodePort



