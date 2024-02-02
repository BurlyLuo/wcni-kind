cat <<EOF | kind create cluster --name=cilium-dual-stack --image=kindest/node:v1.27.3 --config=-
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
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. install CNI
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1

helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set cluster.id=1 --set cluster.name=cilium-dual-stack --set encryption.nodeEncryption=false --set ipam.mode=cluster-pool --set ipv6.enabled=true --set kubeProxyReplacement=disabled --set operator.replicas=1 --set serviceAccounts.cilium.name=cilium --set serviceAccounts.operator.name=cilium-operator --set tunnel=vxlan

# 4. wait all pods ready[need the image support ipv6!!! nettool not support]
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. cgroup v2 verify
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-socket-lb);do docker exec $container ls -al /proc/self/ns/cgroup;done

