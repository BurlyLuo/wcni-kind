#!/bin/bash
set -v

kubectl create ns app-routable-demo
kubectl apply -n app-routable-demo -f ./mutual-auth/nginx-conf-map.yaml
kubectl apply -n app-routable-demo -f ./mutual-auth/zone_svc.yaml
kubectl apply -n app-routable-demo -f ./mutual-auth/echoserver1.yaml
kubectl apply -n app-routable-demo -f ./mutual-auth/echoserver2.yaml
kubectl apply -n app-routable-demo -f ./mutual-auth/nginx-zone.yaml
kubectl apply -n app-routable-demo -f ./mutual-auth/siege.yaml
kubectl get po -n app-routable-demo

cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: no-mutual-auth-echo-app-routeble-demo
  namespace: app-routable-demo
spec:
  endpointSelector:
    matchLabels:
       app: nginx-zone1
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: siege
    authentication:
      mode: "required"
    toPorts:
    - ports:
      - port: "80"
        protocol: TCP
      rules:
        http:
        - method: "GET"
          path: "/app1"
EOF
