#!/bin/bash
set -v
# 1. Install CNI[Calico v3.23.2]
kubectl apply -f ./calico.yaml

kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 1.2. disable bgp fullmesh
cat <<EOF | calicoctl  --allow-version-mismatch apply -f - 
apiVersion: projectcalico.org/v3
items:
- apiVersion: projectcalico.org/v3
  kind: BGPConfiguration
  metadata:
    name: default
  spec:
    logSeverityScreen: Info
    nodeToNodeMeshEnabled: false
kind: BGPConfigurationList
metadata:
EOF

# 1.3. add() bgp configuration for the nodes
cat <<EOF | calicoctl  --allow-version-mismatch apply -f - 
apiVersion: projectcalico.org/v3
kind: Node
metadata:
  annotations:
    projectcalico.org/kube-labels: '{"beta.kubernetes.io/arch":"amd64","beta.kubernetes.io/os":"linux","kubernetes.io/arch":"amd64","kubernetes.io/hostname":"calico-bgp-rr-control-plane","kubernetes.io/os":"linux","node-role.kubernetes.io/control-plane":"","node-role.kubernetes.io/master":"","node.kubernetes.io/exclude-from-external-load-balancers":"","rack":"rack0"}'
  labels:
    beta.kubernetes.io/arch: amd64
    beta.kubernetes.io/os: linux
    kubernetes.io/arch: amd64
    kubernetes.io/hostname: calico-bgp-rr-control-plane
    kubernetes.io/os: linux
    node-role.kubernetes.io/control-plane: ""
    node-role.kubernetes.io/master: ""
    node.kubernetes.io/exclude-from-external-load-balancers: ""
    rack: rack0
  name: calico-bgp-rr-control-plane
spec:
  addresses:
  - address: 10.1.5.10
    type: InternalIP
  bgp:
    asNumber: 65005
    ipv4Address: 10.1.5.10/24
  orchRefs:
  - nodeName: calico-bgp-rr-control-plane
    orchestrator: k8s
status:
  podCIDRs:
  - 10.244.0.0/24
EOF

cat <<EOF | calicoctl  --allow-version-mismatch apply -f - 
apiVersion: projectcalico.org/v3
kind: Node
metadata:
  annotations:
    projectcalico.org/kube-labels: '{"beta.kubernetes.io/arch":"amd64","beta.kubernetes.io/os":"linux","kubernetes.io/arch":"amd64","kubernetes.io/hostname":"calico-bgp-rr-worker","kubernetes.io/os":"linux","rack":"rack0"}'
  creationTimestamp: "2022-12-05T08:40:29Z"
  labels:
    beta.kubernetes.io/arch: amd64
    beta.kubernetes.io/os: linux
    kubernetes.io/arch: amd64
    kubernetes.io/hostname: calico-bgp-rr-worker
    kubernetes.io/os: linux
    rack: rack0
  name: calico-bgp-rr-worker
spec:
  addresses:
  - address: 10.1.5.11
    type: InternalIP
  bgp:
    asNumber: 65005
    ipv4Address: 10.1.5.11/24  
  orchRefs:
  - nodeName: calico-bgp-rr-worker
    orchestrator: k8s
status:
  podCIDRs:
  - 10.244.1.0/24
EOF


cat <<EOF | calicoctl  --allow-version-mismatch apply -f - 
apiVersion: projectcalico.org/v3
kind: Node
metadata:
  annotations:
    projectcalico.org/kube-labels: '{"beta.kubernetes.io/arch":"amd64","beta.kubernetes.io/os":"linux","kubernetes.io/arch":"amd64","kubernetes.io/hostname":"calico-bgp-rr-worker2","kubernetes.io/os":"linux","rack":"rack1"}'
  creationTimestamp: "2022-12-05T08:40:29Z"
  labels:
    beta.kubernetes.io/arch: amd64
    beta.kubernetes.io/os: linux
    kubernetes.io/arch: amd64
    kubernetes.io/hostname: calico-bgp-rr-worker2
    kubernetes.io/os: linux
    rack: rack1
  name: calico-bgp-rr-worker2
spec:
  addresses:
  - address: 10.1.8.10
    type: InternalIP
  bgp:
    asNumber: 65008
    ipv4Address: 10.1.8.10/24
  orchRefs:
  - nodeName: calico-bgp-rr-worker2
    orchestrator: k8s
status:
  podCIDRs:
  - 10.244.2.0/24
EOF

cat <<EOF | calicoctl  --allow-version-mismatch apply -f - 
apiVersion: projectcalico.org/v3
kind: Node
metadata:
  annotations:
    projectcalico.org/kube-labels: '{"beta.kubernetes.io/arch":"amd64","beta.kubernetes.io/os":"linux","kubernetes.io/arch":"amd64","kubernetes.io/hostname":"calico-bgp-rr-worker3","kubernetes.io/os":"linux","rack":"rack1"}'
  creationTimestamp: "2022-12-05T08:40:29Z"
  labels:
    beta.kubernetes.io/arch: amd64
    beta.kubernetes.io/os: linux
    kubernetes.io/arch: amd64
    kubernetes.io/hostname: calico-bgp-rr-worker3
    kubernetes.io/os: linux
    rack: rack1
  name: calico-bgp-rr-worker3
spec:
  addresses:
  - address: 10.1.8.11
    type: InternalIP
  bgp:
    asNumber: 65008
    ipv4Address: 10.1.8.11/24
  orchRefs:
  - nodeName: calico-bgp-rr-worker3
    orchestrator: k8s
status:
  podCIDRs:
  - 10.244.3.0/24
EOF

# 1.4. peer to leaf0 switch
cat <<EOF | calicoctl  --allow-version-mismatch apply -f -
apiVersion: projectcalico.org/v3
kind: BGPPeer
metadata:
  name: rack0-to-leaf0
spec:
  peerIP: 10.1.5.1
  asNumber: 65005
  nodeSelector: rack == 'rack0'
EOF

# 1.5. peer to leaf1 switch
cat <<EOF | calicoctl --allow-version-mismatch  apply -f -
apiVersion: projectcalico.org/v3
kind: BGPPeer
metadata:
  name: rack1-to-leaf1
spec:
  peerIP: 10.1.8.1
  asNumber: 65008
  nodeSelector: rack == 'rack1'
EOF

