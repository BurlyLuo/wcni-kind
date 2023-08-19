#/bin/bash
set -v 

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

