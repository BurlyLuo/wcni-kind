#!/bin/bash
set -v 
cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-conf
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "macvlan",
      "master": "ens257",
      "mode": "bridge",
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
  name: macvlan-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf@eth1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: false
      capabilities:
        drop: ["ALL"]
        add: ["CAP_DAC_OVERRIDE", "CAP_CHOWN", "CAP_NET_BIND_SERVICE"]
EOF


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: macvlan-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf@eth1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: false
      capabilities:
        drop: ["ALL"]
        add: ["CAP_DAC_OVERRIDE", "CAP_CHOWN", "CAP_NET_BIND_SERVICE"]
EOF

