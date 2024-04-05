#/bin/bash
set -v 
# Cilium ingress https
sed -i '/bookinfo\.cilium\.rocks\|hipstershop\.cilium\.rocks/d' /etc/hosts
tee -a /etc/hosts <<<"$(kubectl get svc/cilium-gateway-tls-gateway -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') bookinfo.cilium.rocks hipstershop.cilium.rocks"
curl -kv https://bookinfo.cilium.rocks/details/1 | jq

# eCapture the TLS packet
# bridge_gw=$(ip a | grep 172.18.0.1 -C 2 | grep "global br-" | awk -F " " '{print $NF}')
# ecapture -i $bridge_gw tls -w ingress-https.cap
# sleep 1 && kill -9 $(pidof ecapture)
