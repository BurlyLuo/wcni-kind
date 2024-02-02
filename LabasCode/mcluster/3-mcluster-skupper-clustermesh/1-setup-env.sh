#!/bin/bash
set -v
# wget https://github.com/skupperproject/skupper/releases/download/1.4.2/skupper-cli-1.4.2-linux-amd64.tgz
# tar -xzf skupper-cli-1.4.2-linux-amd64.tgz

# mkdir -p $HOME/bin
# mv skupper $HOME/bin
# echo "export PATH=$PATH:$HOME/bin" >> ~/.bashrc
# source ~/.bashrc
# rm -rf ./skupper-cli-1.4.2-linux-amd64.tgz

cat <<EOF | kind create cluster --name=c1 --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/16"
nodes:
- role: control-plane
- role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

kubectl apply -f ./metallb-native.yaml
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
kubectl apply -f ./c1-address-pool.yaml



cat <<EOF | kind create cluster --name=c2 --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/16"
nodes:
- role: control-plane
- role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

kubectl apply -f ./metallb-native.yaml
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
kubectl apply -f ./c2-address-pool.yaml


kubectx kind-c1
kubectl create ns interconnect
kubens interconnect
skupper init --enable-cluster-permissions --enable-console --enable-flow-collector
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

kubectx kind-c2
kubectl create ns interconnect
kubens interconnect
skupper init --enable-cluster-permissions
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A


skupper token create c2-token.yaml
kubectx kind-c1
skupper link create c2-token.yaml

