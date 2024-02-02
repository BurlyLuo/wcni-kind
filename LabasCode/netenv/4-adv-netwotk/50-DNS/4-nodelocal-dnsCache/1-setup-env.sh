#!/bin/bash
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=dns --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  podSubnet: "10.244.0.0/16"
nodes:
- role: control-plane
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
kubectl apply -f ./flannel.yaml

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. coredns
kubectl -nkube-system patch deploy coredns -p '{"spec":{"replicas": 1}}'

# 6. mod nodelocaldns.yaml
# __PILLAR__DNS__SERVER__ ：表示 kube-dns 这个 Service 的 ClusterIP，可以通过命令 kubectl get svc -n kube-system | grep kube-dns | awk '{ print $3 }' 获取
# __PILLAR__LOCAL__DNS__：表示 DNSCache 本地的 IP，默认为 169.254.20.10
# __PILLAR__DNS__DOMAIN__：表示集群域，默认就是 cluster.local
 
sed -i 's/__PILLAR__DNS__SERVER__/10.96.0.10/g
s/__PILLAR__LOCAL__DNS__/169.254.20.10/g
s/__PILLAR__DNS__DOMAIN__/cluster.local/g' nodelocaldns.yaml

kubectl apply -f ./nodelocaldns.yaml
