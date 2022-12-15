#!/bin/bash
set -v 
date
controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep worker2`

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-conf-1
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "macvlan-whereabouts-conf-1",
    "plugins": [
      {
        "type": "macvlan",
        "master": "net0",
        "mode": "bridge",
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
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-conf-2
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "macvlan-whereabouts-conf-2",
    "plugins": [
      {
        "type": "macvlan",
        "master": "net0",
        "mode": "bridge",
        "ipam": {
          "type": "whereabouts",
          "range": "16.1.5.2-16.1.5.100/24",
          "gateway": "16.1.5.1",
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
  name: macvlan-sbr-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf-1@eth1,macvlan-whereabouts-conf-2@eth2
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
  name: macvlan-sbr-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf-1@eth1,macvlan-whereabouts-conf-2@eth2
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

