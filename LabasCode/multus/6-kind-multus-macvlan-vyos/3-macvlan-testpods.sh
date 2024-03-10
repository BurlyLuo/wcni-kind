#!/bin/bash
set -v 
date

controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep worker2`

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-public
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "macvlan",
      "master": "net1",
      "mode": "bridge",
      "ipam": {
        "type": "whereabouts",
        "range": "100.15.1.200-100.15.1.205/24"
      }
    }'
EOF

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-private
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "macvlan",
      "master": "net2",
      "mode": "bridge",
      "ipam": {
        "type": "whereabouts",
        "range": "172.15.1.200-172.15.1.205/24"
      }
    }'
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: vyos1
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-public@eth1, macvlan-whereabouts-private@eth2
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/vyos/vyos:1.4.9
    command: ["/sbin/init"]
    volumeMount:
    - name: lib-muodules
      mountPath: /lib/modules
    securityContext:
      privileged: true
  volumes:
  - name: lib-muodules
    hostPath: /lib/modules
  nodeName: ${worker_node}
EOF
