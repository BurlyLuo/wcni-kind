#!/bin/bash

set -v
exec &>./install-log-rec.txt

# platform env adapt
sed -i "s/alias ll='ls -lrthF'/alias ll='ls -lhF'/g" ~/.bashrc
source ~/.bashrc | grep err

sed -i "s/namespace: kube-flannel/namespace: kube-system/g" ./flannel.yaml

kubectl apply -f ./flannel.yaml

kubectl get nodes -owide 

kubectl get pods -owide -A 

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: flannel-wireguard
  name: flannel-wireguard
spec:
  selector:
    matchLabels:
      app: flannel-wireguard
  template:
    metadata:
      labels:
        app: flannel-wireguard
    spec:
      containers:
      - image: 192.168.2.100:5000/nettool
        name: nettoolbox
        securityContext:
          privileged: true
---
apiVersion: v1
kind: Service
metadata:
  name: serversvc
spec:
  type: NodePort
  selector:
    app: flannel-wireguard
  ports:
  - name: flannel-wireguard
    port: 8080
    targetPort: 80
    nodePort: 32000
EOF
