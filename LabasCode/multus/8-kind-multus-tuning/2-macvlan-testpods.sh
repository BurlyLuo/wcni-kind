#!/bin/bash
set -v 
date

controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
worker_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep worker2`

# Ticket: https://github.com/containernetworking/plugins/issues/1075
cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-tuning-conf
spec:
  config: '{
    "cniVersion": "0.3.1",
    "name": "tuningexample",
    "plugins": [
       {
         "type": "macvlan",
         "master": "eth0",
         "mode": "bridge",
         "ipam": {
           "type": "whereabouts",
           "range": "15.15.1.200-15.15.1.205/24",
           "gateway": "15.15.1.1",
           "route": [
              { "dst": "0.0.0.0/0"
              }]
           }
       },
       {
         "type": "tuning",
         "sysctl": {
            "net.core.somaxconn": "500",
            "net.ipv4.conf.eth1.arp_filter": "1"
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
  name: macvlan-tuning-pod1
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-tuning-conf@eth1
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
  name: macvlan-tuning-pod2
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-tuning-conf@eth1
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

