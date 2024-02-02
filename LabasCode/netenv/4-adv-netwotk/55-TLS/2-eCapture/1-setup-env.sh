#!/bin/bash
date
set -v

# 1.prep noCNI env[Ubuntu 22.04][https://docs.cilium.io/en/v1.14/installation/kind/#install-cilium]
cat <<EOF | kind create cluster --name=cilium-gwapi-https --image=kindest/node:v1.27.3 --config=-
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

# 3. install gateway-api must have crd
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v0.7.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml

# 4.install cni
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# kubeproxyreplacement Options(--set kubeProxyReplacement=true)
# Gateway API Support Options(--set l7Proxy=true --set gatewayAPI.enabled=true)
# [tls secret: controller_node=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $1}'`]
# docker exec $controller_node bash -c 'apt -y install wget sudo git;wget -c https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local;echo wget done;export PATH=$PATH:/usr/local/go/bin;source ~/.profile;git clone https://github.com/jsha/minica.git;cd minica && go build;/minica/minica --domains '*.cilium.rocks';kubectl create secret tls demo-cert --key=_.cilium.rocks/key.pem --cert=_.cilium.rocks/cert.pem'
# https://github.com/cilium/cilium/issues/24088

kubectl create secret tls demo-cert --key=./minica/_.cilium.rocks/key.pem --cert=./minica/_.cilium.rocks/cert.pem

helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-gwapi-https --set kubeProxyReplacement=true --set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set l7Proxy=true --set gatewayAPI.enabled=true

# 5. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 6. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 7. cgroup v2 verify
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-gwapi-https);do docker exec $container ls -al /proc/self/ns/cgroup;done

