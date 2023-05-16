cat <<EOF | kind create cluster --name=cilium-dual-stack --image=kindest/node:v1.23.4 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
        ipFamily: dual
        apiServerAddress: 127.0.0.1
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
controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-
kubectl get nodes -o wide

# 3. install CNI
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node --set k8sServicePort=6443 --version 1.13.0-rc5 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set cluster.id=1 --set cluster.name=cilium-dual-stack --set encryption.nodeEncryption=false --set ipam.mode=kubernetes --set ipv6.enabled=true --set kubeProxyReplacement=disabled --set operator.replicas=1 --set serviceAccounts.cilium.name=cilium --set serviceAccounts.operator.name=cilium-operator --set tunnel=vxlan
