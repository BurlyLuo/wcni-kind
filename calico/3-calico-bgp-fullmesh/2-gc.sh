#!/bin/bash

set -v

cat <<EOF | kubectl delete -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: calico-bgp-fullmesh
  name: calico-bgp-fullmesh
spec:
  selector:
    matchLabels:
      app: calico-bgp-fullmesh
  template:
    metadata:
      labels:
        app: calico-bgp-fullmesh
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
    app: calico-bgp-fullmesh
  ports:
  - name: calico-bgp-fullmesh
    port: 8080
    targetPort: 80
    nodePort: 32000
EOF

