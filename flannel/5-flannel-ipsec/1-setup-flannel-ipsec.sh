#!/bin/bash

set -v
exec &>./install-log-rec.txt

# platform env adapt
sed -i "s/alias ll='ls -lrthF'/alias ll='ls -lhF'/g" ~/.bashrc
source ~/.bashrc | grep err

sed -i "s/namespace: kube-flannel/namespace: kube-system/g" ./flannel.yaml
dd if=/dev/urandom count=48 bs=1 status=none | xxd -p -c 48

kubectl apply -f ./flannel.yaml

kubectl get nodes -owide 

kubectl get pods -owide -A 

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: flannel-ipsec
  name: flannel-ipsec
spec:
  selector:
    matchLabels:
      app: flannel-ipsec
  template:
    metadata:
      labels:
        app: flannel-ipsec
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
    app: flannel-ipsec
  ports:
  - name: flannel-ipsec
    port: 8080
    targetPort: 80
    nodePort: 32000
EOF
