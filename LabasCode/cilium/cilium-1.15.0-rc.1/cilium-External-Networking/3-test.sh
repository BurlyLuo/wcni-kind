kubectl create ns egress-access
kubectl create ns egress-noaccess

kubectl -n egress-access run cni --image=192.168.2.100:5000/nettool
kubectl -n egress-noaccess run cni --image=192.168.2.100:5000/nettool

cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2
kind: CiliumEgressGatewayPolicy
metadata:
  name: egress-access
spec:
  destinationCIDRs:
  - "11.1.8.0/24"
  selectors:
  - podSelector:
      matchLabels:
        io.kubernetes.pod.namespace: egress-access
  egressGateway:
    nodeSelector:
      matchLabels:
        egress-gw: 'true'
    interface: eth9
EOF
