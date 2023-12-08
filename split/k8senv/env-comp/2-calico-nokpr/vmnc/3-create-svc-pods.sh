#!/bin/bash
set -v 
controller_node=vmnc0
worker_node=vmnc1

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
    image: 192.168.2.100:5000/xcni:9494
    imagePullPolicy: Always
    securityContext:
      privileged: true
  restartPolicy: Always
  nodeName: ${controller_node}

EOF

cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: Service
metadata:
  labels:
    run: client
  name: clientsvc
spec:
  clusterIP: 10.43.94.94
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
    run: server
  name: server
spec:
  containers:
  - name: server
    image: 192.168.2.100:5000/xcni:9495
    imagePullPolicy: Always
    securityContext:
      privileged: true
  restartPolicy: Always
  nodeName: ${worker_node}

EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  labels:
    run: server
  name: serversvc
spec:
  clusterIP: 10.43.94.95
  ports:
  - port: 9495
    protocol: TCP
    targetPort: 9495
  selector:
    run: server
EOF

