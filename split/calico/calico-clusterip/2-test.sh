#!/bin/bash
set -v 
controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name | grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name | grep worker2`

# client pod and service
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: client
  name: client
spec:
  containers:
  - name: client
    image: 192.168.2.100:5000/nettool:9494
    imagePullPolicy: Always
  restartPolicy: Always
  nodeName: ${controller_node}

EOF

cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: Service
metadata:
  labels:
    run: client
  name: client-svc
spec:
  ports:
  - port: 9494
    protocol: TCP
    targetPort: 9494
  selector:
    run: client
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: backend
  name: backend
spec:
  containers:
  - name: backend
    image: 192.168.2.100:5000/nettool:9495
    imagePullPolicy: Always
  restartPolicy: Always
  nodeName: ${worker_node}

EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  labels:
    run: backend
  name: backend-svc
spec:
  ports:
  - port: 9495
    protocol: TCP
    targetPort: 9495
  selector:
    run: backend
EOF

