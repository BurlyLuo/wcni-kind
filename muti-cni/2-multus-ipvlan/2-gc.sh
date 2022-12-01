
cat <<EOF | kubectl delete -f -
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
  nodeName: bpf1
EOF



cat <<EOF | kubectl delete -f -
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
        "range": "10.1.1.20-10.1.1.30/24"
      }
    }'
EOF


cat <<EOF | kubectl delete -f -
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

