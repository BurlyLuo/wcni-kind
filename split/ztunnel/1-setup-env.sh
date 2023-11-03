#!/bin/bash
set -v
# 1.prep noCNI env
cat <<EOF | kind create cluster --name=ambient --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
#networking:
        #disableDefaultCNI: true
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

# 3. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 4. install istio with ambient profile
/usr/bin/istioctl-0.0.0-ambient install --set profile=ambient <<< 'y'

kubectl apply -f istio-0.0.0-ambient.191fe680b52c1754ee72a06b3e0d3f9d116f2e82/metallb/

# 5. deploy demo app
kubectl apply -f istio-0.0.0-ambient.191fe680b52c1754ee72a06b3e0d3f9d116f2e82/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f istio-0.0.0-ambient.191fe680b52c1754ee72a06b3e0d3f9d116f2e82/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl apply -f https://raw.githubusercontent.com/linsun/sample-apps/main/sleep/sleep.yaml
kubectl apply -f https://raw.githubusercontent.com/linsun/sample-apps/main/sleep/notsleep.yaml
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 6. test non-ztunnel func
kubectl exec deploy/sleep -- curl -s http://istio-ingressgateway.istio-system/productpage | head -n1
kubectl exec deploy/sleep -- curl -s http://172.18.0.200/productpage | head -n1
kubectl exec deploy/sleep -- curl -s http://productpage:9080/ | head -n1
kubectl exec deploy/notsleep -- curl -s http://productpage:9080/ | head -n1

# 7. test enabel ztunnel func
kubectl label namespace default istio.io/dataplane-mode=ambient
kubectl exec deploy/sleep -- curl -s http://istio-ingressgateway.istio-system/productpage | head -n1
kubectl exec deploy/sleep -- curl -s http://172.18.0.200/productpage | head -n1
kubectl exec deploy/sleep -- curl -s http://productpage:9080/ | head -n1
kubectl exec deploy/notsleep -- curl -s http://productpage:9080/ | head -n1

