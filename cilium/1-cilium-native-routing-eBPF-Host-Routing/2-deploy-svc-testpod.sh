#!/bin/bash
set -v 
date
controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep worker2`

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: svc-client
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: true
  nodeName: ${controller_node}
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: svc-server
  labels:
    app: svc-server
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: true
  nodeName: ${worker_node}
EOF


cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: Service
metadata:
  name: svc-server
spec:
  type: NodePort
  selector:
    app: svc-server
  ports:
  - name: cni
    port: 8080
    targetPort: 80
    nodePort: 32000
EOF
