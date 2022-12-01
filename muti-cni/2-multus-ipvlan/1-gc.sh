#!/bin/bash
set -v
cat <<EOF | kubectl delete -f -
apiVersion: v1
kind: Pod
metadata:
  name: muti-cni-pod
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf@net1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: false
      capabilities:
        add: ["NET_ADMIN"]
EOF

cat <<EOF | kubectl delete -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-conf
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "macvlan",
      "master": "ens160",
      "mode": "bridge",
      "ipam": {
        "type": "whereabouts",
        "range": "192.168.2.200-192.168.2.205/24"
      }
    }'
EOF
