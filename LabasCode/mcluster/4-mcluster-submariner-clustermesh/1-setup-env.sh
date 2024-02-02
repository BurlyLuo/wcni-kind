#!/bin/bash
set -v
rm -rf broker-info.subm* > /dev/null 2>&1
cat <<EOF | kind create cluster --name=c1 --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  apiServerAddress: 192.168.2.99
  podSubnet: "10.22.0.0/16"
  serviceSubnet: "10.77.0.0/16"
nodes:
- role: control-plane
- role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]

#kubeadmConfigPatches:
#  - |
#    apiVersion: kubeadm.k8s.io/v1beta2
#    kind: ClusterConfiguration
#    metadata:
#      name: config
#    networking:
#      podSubnet: "10.22.0.0/16"
#      serviceSubnet: "10.77.0.0/16"
#      dnsDomain: c1.local
EOF
kubectl --context=kind-c1 apply -f ./flannel-c1.yaml
kubectl --context=kind-c1 wait --timeout=100s --for=condition=Ready=true pods --all -A


cat <<EOF | kind create cluster --name=c2 --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  apiServerAddress: 192.168.2.99
  podSubnet: "10.33.0.0/16"
  serviceSubnet: "10.88.0.0/16"
nodes:
- role: control-plane
- role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]

#kubeadmConfigPatches:
#  - |
#    apiVersion: kubeadm.k8s.io/v1beta2
#    kind: ClusterConfiguration
#    metadata:
#      name: config
#    networking:
#      podSubnet: "10.33.0.0/16"
#      serviceSubnet: "10.88.0.0/16"
#      dnsDomain: c2.local
EOF
kubectl --context=kind-c2 apply -f ./flannel-c2.yaml
kubectl --context=kind-c2 wait --timeout=100s --for=condition=Ready=true pods --all -A


kubectl --context=kind-c1 label node c1-worker submariner.io/gateway=true 

kubectl --context=kind-c2 label node c2-worker submariner.io/gateway=true

subctl --context=kind-c1 deploy-broker

subctl --context=kind-c1 join broker-info.subm --natt=false --clusterid kind-c1
kubectl --context=kind-c1 wait --timeout=100s --for=condition=Ready=true pods --all -A

subctl --context=kind-c2 join broker-info.subm --natt=false --clusterid kind-c2
kubectl --context=kind-c2 wait --timeout=100s --for=condition=Ready=true pods --all -A


kubectl --context=kind-c2 run c2 --image=192.168.2.100:5000/nettool
kubectl --context=kind-c2 expose pod c2 --port=80
subctl --context=kind-c2 export service --namespace default c2
kubectl --context=kind-c2 wait --timeout=100s --for=condition=Ready=true pods --all -A

kubectl --context=kind-c1 run c1 --image=192.168.2.100:5000/nettool
kubectl --context=kind-c1 expose pod c1 --port=80
subctl --context=kind-c1 export service --namespace default c1
kubectl --context=kind-c1 wait --timeout=100s --for=condition=Ready=true pods --all -A

subctl show gateways
subctl show connections

