#!/bin/bash
set -v 
date

controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep worker2`

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: multihoming-sbr-conf1
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "multihoming",
    "plugins": [
      {
        "type": "macvlan",
        "master": "eth0",
        "mode": "bridge",
        "ipam": {
          "type": "static",
          "addresses": [
            {
                "address": "10.10.0.2/24",
                "gateway": "10.10.0.1"
            },
            {
                "address": "10.20.0.2/24",
                "gateway": "10.20.0.1"
            }
        ]
        }
      },
      {
        "type": "sbr"
      }
    ]
  }' 
EOF

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: multihoming-sbr-conf2
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "multihoming",
    "plugins": [
      {
        "type": "macvlan",
        "master": "eth0",
        "mode": "bridge",
        "ipam": {
          "type": "static",
          "addresses": [
            {
                "address": "10.10.0.20/24",
                "gateway": "10.10.0.1"
            },
            {
                "address": "10.20.0.20/24",
                "gateway": "10.20.0.1"
            }
        ]
        }
      },
      {
        "type": "sbr"
      }
    ]
  }' 
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: multihoming-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: multihoming-sbr-conf1@eth1
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
  name: multihoming-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: multihoming-sbr-conf2@eth1
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

