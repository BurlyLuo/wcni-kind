# helm install cilium cilium/cilium --set k8sServiceHost=$controller_node --set k8sServicePort=6443 --version 1.12.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set cluster.name=clab-bgp-cplane --set tunnel=disabled --set ipam.mode=kubernetes --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set bgpControlPlane.enabled=true --set k8s.requireIPv4PodCIDR=true

helm repo add cilium https://helm.cilium.io/
helm install -n kube-system cilium cilium/cilium --version v1.12.0 -f ./values.yaml
