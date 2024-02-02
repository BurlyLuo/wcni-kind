#!/bin/bash
set -v
kubectl delete ccnp port-80-policy > /dev/null 2>&1

cat <<EOF | kubectl apply -f -
apiVersion: "cilium.io/v2"
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: "control-plane-apiserver"
spec:
  description: "permit kube-apiserver 6443"
  nodeSelector:
    matchLabels:
      node-role.kubernetes.io/control-plane: ""
  ingress:
  - toPorts:
    - ports:
      - port: "6443"
        protocol: TCP
EOF

cat <<EOF | kubectl apply -f -
apiVersion: "cilium.io/v2"
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: "default-deny"
spec:
  description: "block all traffic"
  nodeSelector: {}
  ingress:
  - fromEntities:
    - cluster
EOF

echo "deny all traffic | test port 80:"
docker exec -it clab-cilium-host-firewall-client curl -m 1 -v 12.1.5.11

# add label:
for node in $(kubectl get node -o name);do kubectl label $node node=ccnp --overwrite;done

cat <<EOF | kubectl apply -f -
apiVersion: "cilium.io/v2"
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: "port-80-policy"
spec:
  description: "clab+kind"
  nodeSelector:
    matchLabels:
      node: ccnp
  ingress:
  - toPorts:
    - ports:
      - port: "80"
        protocol: TCP
EOF

echo "permit eth1 port 80 | test port 80:" && sleep 2
docker exec -it clab-cilium-host-firewall-client curl -m 1 -v 12.1.5.11

