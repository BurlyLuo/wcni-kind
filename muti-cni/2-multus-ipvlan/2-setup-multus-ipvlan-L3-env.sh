#!/bin/bash
set -v
exec &>./ipvlan-l3-install-log-rec.txt

kubectl apply -f calico.yaml

kubectl apply -f ../1-multus-macvlan/multus-cni/deployments/multus-daemonset.yml

kubectl apply -f ../1-multus-macvlan/whereabouts/doc/crds/

kubectl get nodes -o wide

kubectl get pods -o wide -A

sleep 30

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
      "master": "ens160",
      "mode": "l3",
      "ipam": {
        "type": "whereabouts",
        "range": "10.1.1.10-10.1.1.20/24"
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
  nodeName: bpf1
EOF



cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-confl3
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "ipvlan",
      "master": "ens160",
      "mode": "l3",
      "ipam": {
        "type": "whereabouts",
        "range": "10.1.2.20-10.1.2.30/24"
      }
    }'
EOF


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: muti-cni-pod-ipvlanl3
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-confl3@net1
spec:
  containers:
  - name: nettool
    image: 192.168.2.100:5000/nettool
    securityContext:
      privileged: false
      capabilities:
        add: ["NET_ADMIN"]
  nodeName: bpf1
EOF


sleep 5

kubectl exec -it muti-cni-pod -- ifconfig -a
kubectl exec -it muti-cni-pod-ipvlanl3 -- ifconfig -a

kubectl exec -it muti-cni-pod -- ip r d default via 169.254.1.1 dev eth0
kubectl exec -it muti-cni-pod -- ip r a default dev net1

kubectl exec -it muti-cni-pod-ipvlanl3 -- ip r d default via 169.254.1.1 dev eth0
kubectl exec -it muti-cni-pod-ipvlanl3 -- ip r a default dev net1

