#!/bin/bash
date
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=cilium-kubeproxy --image=kindest/node:v1.23.4 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
        # kubeProxyMode: "none" # Enable KubeProxy

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

# 3.install cni[Cilium 1.13.0-rc5]
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.13.0-rc5 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-kubeproxy --set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8"

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. install cni-demo pods and service
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: wluo
  name: wluo
spec:
  selector:
    matchLabels:
      app: wluo
  template:
    metadata:
      labels:
        app: wluo
    spec:
      containers:
      - image: 192.168.2.100:5000/nettool
        name: nettoolbox
        env:
          - name: NETTOOL_NODE_NAME
            valueFrom:
              fieldRef:
                fieldPath: spec.nodeName
        securityContext:
          privileged: true
---
apiVersion: v1
kind: Service
metadata:
  name: wluo
spec:
  type: NodePort
  selector:
    app: wluo
  ports:
  - name: wluo
    port: 80
    targetPort: 80
    nodePort: 32000
EOF

