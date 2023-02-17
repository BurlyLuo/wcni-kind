#/bin/bash

controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name | grep -E "control-plane|bpf1"`
if [[ $controller_node == "bpf1" ]]
then
   controller_node="192.168.2.71"
else
   controller_node="controller_node"
fi

helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node --set k8sServicePort=6443 --version 1.13.0-rc5 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=socketlb --set kubeProxyReplacement=strict --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set tunnel=disabled --set bpf.masquerade=true --set installNoConntrackIptablesRules=true --set gatewayAPI.enabled=true

