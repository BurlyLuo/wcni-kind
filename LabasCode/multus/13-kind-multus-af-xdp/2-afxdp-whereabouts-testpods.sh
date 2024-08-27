#!/bin/bash
set -v 
date

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: afxdp-whereabouts-conf-1
  annotations:
    k8s.v1.cni.cncf.io/resourceName: afxdp/myPool
spec:
  config: '{
      "cniVersion": "0.3.0",
      "type": "afxdp",
      "mode": "primary",
      "logFile": "afxdp-cni.log",
      "logLevel": "debug",
      "ipam": {
        "type": "whereabouts",
        "range": "15.15.1.200-15.15.1.205/24"
      }
    }'
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: afxdp-whereabouts-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: afxdp-whereabouts-conf-1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    resources:
      requests:
        afxdp/myPool: '1'
      limits:
        afxdp/myPool: '1'
    securityContext:
      privileged: true
      capabilities:
        add: ["NET_ADMIN"]
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: afxdp-whereabouts-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: afxdp-whereabouts-conf-1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    resources:
      requests:
        afxdp/myPool: '1'
      limits:
        afxdp/myPool: '1'
    securityContext:
      privileged: true
      capabilities:
        add: ["NET_ADMIN"]
EOF

