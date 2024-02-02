#!/bin/bash
date
set -v

controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep worker2`

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: ipvlanl3-whereabouts-conf-1
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "ipvlan",
      "master": "eth0",
      "mode": "l3",
      "ipam": {
        "type": "whereabouts",
        "range": "15.1.1.10-15.1.1.20/24"
      }
    }'
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ipvlanl3-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: ipvlanl3-whereabouts-conf-1@eth1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: false
      capabilities:
        add: ["NET_ADMIN"]
  nodeName: ${controller_node}
EOF


cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: ipvlanl3-whereabouts-conf-2
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "ipvlan",
      "master": "eth0",
      "mode": "l3",
      "ipam": {
        "type": "whereabouts",
        "range": "15.1.2.20-15.1.2.30/24"
      }
    }'
EOF


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ipvlanl3-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: ipvlanl3-whereabouts-conf-2@eth1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: false
      capabilities:
        add: ["NET_ADMIN"]
  nodeName: ${controller_node}
EOF

