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

# 8. enable ambient mode l7 func
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: Gateway
metadata:
 name: productpage
 annotations:
   istio.io/service-account: bookinfo-productpage
spec:
 gatewayClassName: istio-mesh
EOF

# 9. review app l7 proxy
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: Gateway
metadata:
 name: reviews
 annotations:
   istio.io/service-account: bookinfo-reviews
spec:
 gatewayClassName: istio-mesh
EOF

# 9.1. Create DR
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: reviews
spec:
  host: reviews
  trafficPolicy:
    loadBalancer:
      simple: RANDOM
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
  - name: v3
    labels:
      version: v3
EOF

# 9.2. Create VS
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
    - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
      weight: 90
    - destination:
        host: reviews
        subset: v2
      weight: 10
EOF

# 10. Test review app
kubectl exec -it deploy/sleep -- sh -c 'for i in $(seq 1 100); do curl -s http://istio-ingressgateway.istio-system/productpage | grep reviews-v.-; done' | sort | uniq -c

