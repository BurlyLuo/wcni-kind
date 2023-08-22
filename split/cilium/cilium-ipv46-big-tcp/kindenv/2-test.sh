#/bin/bash
set -v 

control_node=$(docker ps -a --format "table {{.Names}}" | grep control-plane)
docker exec -it $control_node bash -c "cilium config set enable-ipv4-big-tcp true && cilium config set enable-ipv6-big-tcp true"
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -nkube-system

kubectl delete -f ./netperf.yaml;kubectl apply -f ./netperf.yaml
kubectl wait --timeout=100s --for=condition=Ready=true pods --all

kubectl exec netperf-server -- ip -d -j link show dev eth0 | jq -c '.[0].gso_max_size'
kubectl exec netperf-client -- ip -d -j link show dev eth0 | jq -c '.[0].gso_max_size'

echo "IPv4 BIG TCP"
NETPERF_SERVER=`kubectl get pod netperf-server -o jsonpath='{.status.podIPs}' | jq -r -c '.[].ip | select(contains(".") == true)'`
echo $NETPERF_SERVER
kubectl exec netperf-client -- netperf  -t TCP_RR -H ${NETPERF_SERVER} -- -r80000:80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT

echo "IPv6 BIG TCP"
NETPERF_SERVER=`kubectl get pod netperf-server -o jsonpath='{.status.podIPs}' | jq -r -c '.[].ip | select(contains(":") == true)'`
echo $NETPERF_SERVER
kubectl exec netperf-client -- netperf  -t TCP_RR -H ${NETPERF_SERVER} -- -r80000:80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT





echo "contrast case"
kubectl delete -f ./netperf.yaml

control_node=$(docker ps -a --format "table {{.Names}}" | grep control-plane)
docker exec -it $control_node bash -c "cilium config set enable-ipv4-big-tcp false && cilium config set enable-ipv6-big-tcp false"

kubectl wait --timeout=100s --for=condition=Ready=true pods --all -nkube-system

kubectl apply -f ./netperf.yaml
kubectl wait --timeout=100s --for=condition=Ready=true pods --all

kubectl exec netperf-server -- ip -d -j link show dev eth0 | jq -c '.[0].gso_max_size'
kubectl exec netperf-client -- ip -d -j link show dev eth0 | jq -c '.[0].gso_max_size'

echo "IPv4 BIG TCP"
NETPERF_SERVER=`kubectl get pod netperf-server -o jsonpath='{.status.podIPs}' | jq -r -c '.[].ip | select(contains(".") == true)'`
echo $NETPERF_SERVER
kubectl exec netperf-client -- netperf  -t TCP_RR -H ${NETPERF_SERVER} -- -r80000:80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT

echo "IPv6 BIG TCP"
NETPERF_SERVER=`kubectl get pod netperf-server -o jsonpath='{.status.podIPs}' | jq -r -c '.[].ip | select(contains(":") == true)'`
echo $NETPERF_SERVER
kubectl exec netperf-client -- netperf  -t TCP_RR -H ${NETPERF_SERVER} -- -r80000:80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT

