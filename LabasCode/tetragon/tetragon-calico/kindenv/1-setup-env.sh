#!/bin/bash
set -v
# 1.prep noCNI env
cat <<EOF | kind create cluster --name=calico-ipip --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
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

# 3. install CNI[Calico v3.23.2]
kubectl apply -f calico.yaml

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. install tetragon
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

helm install tetragon cilium/tetragon -n kube-system --version 0.10.0 --set tetragon.btf="/sys/kernel/btf/vmlinux" --set tetragon.enableCiliumAPI=false --set tetragon.exportAllowList="" --set tetragon.exportDenyList="" --set tetragon.exportFilename="tetragon.log" --set tetragon.enableProcessCred=true --set tetragon.enableProcessNs=true --set tetragonOperator.enabled=true

