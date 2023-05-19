#/bin/bash
set -v
# exec &>./cilium-gateway-api-http.log
date
# 1.env info
lsb_release -a

kubectl get nodes -o wide

# 2.Cilium ingress http demo
GATEWAY=$(kubectl get gateway my-gateway -o jsonpath='{.status.addresses[0].value}')
curl -v http://"$GATEWAY"/details/1 | jq
