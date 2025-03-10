#!/bin/bash
date
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=cilium-mutual-auth --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  # kubeProxyMode: "none" # Enable KubeProxy

nodes:
  - role: control-plane
    extraPortMappings:
    - containerPort: 4245
      hostPort: 4245
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

# 3.install cni[Cilium 1.13.0-rc5]
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# Mutual-Auth Options(--set authentication.mutual.spire.enabled=true --set authentication.mutual.spire.install.enabled=true --set hubble.relay.enabled=true --set hubble.ui.enabled=true)
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-mutual-auth --set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set authentication.mutual.spire.enabled=true --set authentication.mutual.spire.install.enabled=true --set hubble.relay.enabled=true --set hubble.ui.enabled=true

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. separate namesapce and cgroup v2 verify [https://github.com/cilium/cilium/pull/16259 && https://docs.cilium.io/en/stable/installation/kind/#install-cilium]
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-mutual-auth);do docker exec $container ls -al /proc/self/ns/cgroup;done
mount -l | grep cgroup && docker info | grep "Cgroup Version" | awk '$1=$1'

