#!/bin/bash
date
set -v

kind create cluster --name=cilium-native-routing --config=./kind-cilium.yaml --image=kindest/node:v1.23.4

controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-
kubectl get nodes -owide

helm template cilium cilium/cilium --set k8sServiceHost=$controller_node --set k8sServicePort=6443  --version 1.12.0 --namespace kube-system --set kubeProxyReplacement=strict --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR=10.0.0.0/16 --set bpf.masquerade=true --set ipam.mode=kubernetes --set tunnel=disabled > ./cilium-native-routing.yaml
kubectl apply -f ./cilium-native-routing.yaml

for i in $(docker ps  -a --format "table {{.Names}}"|grep cilium-native-routing );do echo $i;docker cp /usr/bin/cilium $i:/usr/bin/cilium;docker cp /usr/bin/ping $i:/usr/bin/ping;docker exec -it $i  bash -c "sed -i -e 's/jp.archive.ubuntu.com\|archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list";docker exec -it $i bash -c "apt-get -y update >/dev/null && apt-get -y install net-tools tcpdump lrzsz >/dev/null";done

<<EOF

kubectl apply -f cni.yaml
for i in `kubectl get pods --no-headers | awk -F " " '{print $1}'`;do echo $i;kubectl exec -it $i -- ping -c 1 baidu.com;kubectl exec -it $i -- nslookup kubernetes;done

EOF
