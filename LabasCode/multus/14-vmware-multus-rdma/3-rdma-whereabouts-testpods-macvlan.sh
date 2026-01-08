#!/bin/bash
set -v 
date

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-conf-ens38
spec:
  config: '{
    "cniVersion": "0.3.1",
    "plugins": [
      {
        "type": "macvlan",
        "master": "ens38",
        "ipam": {
          "type": "whereabouts",
          "range": "15.1.5.2-15.1.5.100/24",
          "gateway": "15.1.5.1",
          "route": [
            { "dst": "0.0.0.0/0"
          }]
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
  name: rdma-macvlan-whereabouts-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf-ens38
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/ubuntu:20.04
    command: ["/bin/sleep", "infinity"]
    securityContext:
      privileged: true
      #capabilities:
      #  add: ["NET_ADMIN"]
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: rdma-macvlan-whereabouts-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf-ens38
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/ubuntu:20.04
    command: ["/bin/sleep", "infinity"]
    securityContext:
      privileged: true
      #capabilities:
      #  add: ["NET_ADMIN"]
EOF
