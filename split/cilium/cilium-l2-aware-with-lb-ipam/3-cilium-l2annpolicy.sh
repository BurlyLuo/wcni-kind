#/bin/bash
set -v

cat <<EOF | kubectl apply -f -
apiVersion: "cilium.io/v2alpha1"
kind: CiliumL2AnnouncementPolicy
metadata:
  name: wluo
spec:
  serviceSelector:
    matchLabels:
      app: wluo 
  nodeSelector:
    matchLabels:
      kubernetes.io/os: linux
  interfaces:
  - eth1
  externalIPs: true
  loadBalancerIPs: true
EOF

kubectl patch svc wluo --patch '{"metadata": {"labels": {"app": "wluo"}}}'

