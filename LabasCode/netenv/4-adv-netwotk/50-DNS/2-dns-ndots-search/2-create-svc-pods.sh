#!/bin/bash
set -v 
controller_node=dns-ndots-search-control-plane
worker_node=dns-ndots-search-worker

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
  name: clientsvc
spec:
  type: LoadBalancer
  clusterIP: 10.96.94.94
  ports:
  - port: 9494
    protocol: TCP
    targetPort: 9494
    nodePort: 32094
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
    run: server
  name: serversvc
spec:
  type: LoadBalancer
  clusterIP: 10.96.94.95
  ports:
  - port: 9495
    protocol: TCP
    targetPort: 9495
    nodePort: 32095
  selector:
    run: server
EOF

