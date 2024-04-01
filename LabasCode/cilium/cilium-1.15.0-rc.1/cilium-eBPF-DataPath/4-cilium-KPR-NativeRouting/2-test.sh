#!/bin/bash
controller_node_name=`kubectl get nodes -o wide | grep control-plane | awk -F " " '{print $1}'`
worker_node_name=`kubectl get nodes -o wide | awk -F " " '{print $1}' | grep 'worker$'`

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
  nodeName: ${controller_node_name}

EOF

cat <<EOF | kubectl apply -f - 
apiVersion: v1
kind: Service
metadata:
  labels:
    run: client
  name: clientsvc
spec:
  type: NodePort
  clusterIP: 10.96.94.94
  ports:
  - port: 9494
    protocol: TCP
    targetPort: 9494
    nodePort: 30494
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
  nodeName: ${worker_node_name}

EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  labels:
    run: server
  name: serversvc
spec:
  type: NodePort
  clusterIP: 10.96.94.95
  ports:
  - port: 9495
    protocol: TCP
    targetPort: 9495
    nodePort: 30495
  selector:
    run: server
EOF

