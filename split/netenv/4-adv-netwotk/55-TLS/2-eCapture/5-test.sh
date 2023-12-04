#/bin/bash
set -v 

wget http://192.168.2.100/k3s/go/ecapture/ecapture
chmod +x ecapture

ifname=$(ip a | grep 172.18.0.1 | awk -F " " '{print $NF}')
./ecapture tls -i $ifname -w cilium-gtw-https.cap

# Cilium ingress https
controller_node=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $1}'`
sed -i '/bookinfo\.cilium\.rocks\|hipstershop\.cilium\.rocks/d' /etc/hosts
tee -a /etc/hosts <<<"$(kubectl get svc/cilium-gateway-tls-gateway -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') bookinfo.cilium.rocks hipstershop.cilium.rocks"

curl --cacert ./minica/minica.pem -v https://bookinfo.cilium.rocks/details/1 | jq

kill -9 $(pgrep ecapture)
rm -rf ./ecapture
