kubectl delete ciliumbgppeeringpolicies rack0 rack1 > /dev/null 2>&1

cat <<EOF | kubectl apply -f -
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumBGPPeeringPolicy
metadata:
  name: rack0
spec:
  nodeSelector:
    matchLabels:
      rack: rack0
  virtualRouters:
  - localASN: 65005
    serviceSelector:
      matchExpressions:
        - {key: wluo, operator: NotIn, values: ["wluo"]}
    exportPodCIDR: true
    neighbors:
    - peerAddress: "10.1.5.1/24"
      peerASN: 65005
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumBGPPeeringPolicy
metadata:
  name: rack1
spec:
  nodeSelector:
    matchLabels:
      rack: rack1
  virtualRouters:
  - localASN: 65008
    serviceSelector:
      matchExpressions:
        - {key: wluo, operator: NotIn, values: ["wluo"]}
    exportPodCIDR: true
    neighbors:
    - peerAddress: "10.1.8.1/24"
      peerASN: 65008
EOF

