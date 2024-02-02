#/bin/bash
set -v 

# Cilium ingress https demo
controller_node=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $1}'`
docker cp $controller_node:/minica/minica.pem ./minica.pem

sed -i '/bookinfo\.cilium\.rocks\|hipstershop\.cilium\.rocks/d' /etc/hosts
tee -a /etc/hosts <<<"$(kubectl get svc/cilium-ingress-tls-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') bookinfo.cilium.rocks hipstershop.cilium.rocks"

curl --cacert minica.pem -v https://bookinfo.cilium.rocks/details/1 | jq


