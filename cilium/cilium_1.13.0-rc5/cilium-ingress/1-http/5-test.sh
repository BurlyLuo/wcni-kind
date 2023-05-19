#/bin/bash
set -v
# exec &>./cilium-ingress-http.log
date
# 1.env info
lsb_release -a

kubectl get nodes -o wide

# 2.Cilium ingress http demo
HTTP_INGRESS=$(kubectl get ingress basic-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -v --fail -s http://"$HTTP_INGRESS"/details/1 | jq


