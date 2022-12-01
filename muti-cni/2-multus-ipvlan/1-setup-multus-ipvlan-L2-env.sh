#!/bin/bash
set -v
exec &>./ipvlan-l2-install-log-rec.txt

kubectl apply -f calico.yaml

kubectl apply -f ../1-multus-macvlan/multus-cni/deployments/multus-daemonset.yml

kubectl apply -f ../1-multus-macvlan/whereabouts/doc/crds/

kubectl get nodes -o wide

kubectl get pods -o wide -A

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-conf
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "ipvlan",
      "mode": "l2",
      "master": "ens160",
      "ipam": {
        "type": "whereabouts",
        "range": "192.168.2.200-192.168.2.205/24"
      }
    }'
EOF

cat <<EOF | kubectl apply -f -
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

sleep 5

kubectl exec -it muti-cni-pod -- ifconfig -a

kubectl exec -it muti-cni-pod -- ip route add 0.0.0.0/0 via 192.168.2.1 table 100
kubectl exec -it muti-cni-pod -- ip rule add from 192.168.2.0/24 table 100

kubectl exec -it muti-cni-pod -- bash -c "ping -c 1 114.114.114.114 -I 192.168.2.200"

kubectl exec -it muti-cni-pod -- ip rule s

kubectl exec -it muti-cni-pod -- ip r s t 100
