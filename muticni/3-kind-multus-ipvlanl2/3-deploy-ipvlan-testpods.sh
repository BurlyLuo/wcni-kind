#!/bin/bash
set -v 
date
controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep worker2`

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: ipvlanl2-whereabouts-conf
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "ipvlan",
      "mode": "l2",
      "master": "eth0",
      "ipam": {
        "type": "whereabouts",
        "range": "172.18.0.200-172.18.0.205/24"
      }
    }'
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ipvlan-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: ipvlanl2-whereabouts-conf@eth1
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
apiVersion: v1
kind: Pod
metadata:
  name: ipvlan-pod-x
  annotations:
    k8s.v1.cni.cncf.io/networks: ipvlanl2-whereabouts-conf@eth1
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
apiVersion: v1
kind: Pod
metadata:
  name: ipvlan-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: ipvlanl2-whereabouts-conf@eth1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: false
      capabilities:
        add: ["NET_ADMIN"]
  nodeName: ${worker_node}
EOF

