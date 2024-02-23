#/bin/bash
set -v 
# Cilium ingress https
sed -i '/bookinfo\.cilium\.rocks\|hipstershop\.cilium\.rocks/d' /etc/hosts
tee -a /etc/hosts <<<"$(kubectl get svc/cilium-gateway-tls-gateway -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') bookinfo.cilium.rocks hipstershop.cilium.rocks"

curl -kv https://bookinfo.cilium.rocks/details/1 | jq

