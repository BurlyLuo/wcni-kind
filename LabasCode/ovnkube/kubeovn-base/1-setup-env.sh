#!/bin/bash
set -v
# 1.prep noCNI env
cat <<EOF | kind create cluster --name=kubeovn-env --image=kindest/node:v1.27.3 --config=-
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

# 3.install CNI
kubectl label node -lbeta.kubernetes.io/os=linux kubernetes.io/os=linux --overwrite
kubectl label node -lnode-role.kubernetes.io/control-plane kube-ovn/role=master --overwrite
helm repo add kubeovn https://kubeovn.github.io/kube-ovn/ > /dev/null 2>&1

helm install kube-ovn kubeovn/kube-ovn --version=0.1.0 --set MASTER_NODES=$controller_node_ip --set global.registry.address=192.168.2.100:5000/kubeovn --set global.images.kubeovn.repository=kube-ovn --set global.images.kubeovn.tag=v1.12.0 --set networking.NET_STACK=ipv4 --set networking.NETWORK_TYPE=geneve --set networking.TUNNEL_TYPE=vxlan --set debug.ENABLE_MIRROR=true

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. ovs status
kubectl -nkube-system exec -it ds/ovs-ovn -- ovs-vsctl show

