#!/bin/bash
date
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=calico-fullmesh-ebpf --image=kindest/node:v1.23.4 --config=-
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
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/master:NoSchedule-
kubectl get nodes -o wide

# 3. install CNI[Calico v3.23.2]
KUBERNETES_SERVICE_HOST=`kubectl get nodes --selector=node-role.kubernetes.io/master -o jsonpath='{$.items[*].status.addresses[?(@.type=="InternalIP")].address}'`
echo $KUBERNETES_SERVICE_HOST
cat <<EOF | kubectl apply -f -
kind: ConfigMap
apiVersion: v1
metadata:
  name: kubernetes-services-endpoint
  namespace: kube-system
data:
  KUBERNETES_SERVICE_HOST: "${KUBERNETES_SERVICE_HOST}"
  KUBERNETES_SERVICE_PORT: "6443"

EOF

kubectl apply -f calico.yaml

# 4. Enable BPF
kubectl -nkube-system wait --timeout=60s --for=condition=Ready=true pod -l k8s-app=calico-node

calicoctl --allow-version-mismatch patch felixconfiguration default --patch='{"spec": {"bpfEnabled": true}}'

# 5. wait all pods ready
kubectl wait --timeout=45s --for=condition=Ready=true pods --all -A

