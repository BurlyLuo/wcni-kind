#/bin/bash
set -v 
# GSO SIZE
kubectl exec netperf-server -- ip -d -j link show dev eth0 | jq -c '.[0].gso_max_size'
kubectl exec netperf-client -- ip -d -j link show dev eth0 | jq -c '.[0].gso_max_size'

#NETPERF_SERVER IPV6 Address
NETPERF_SERVER=`kubectl get pod netperf-server -o jsonpath='{.status.podIPs}' | jq -r -c '.[].ip | select(contains(":") == true)'`
echo $NETPERF_SERVER

kubectl get pods -owide

# Test
kubectl exec netperf-client -- netperf  -t TCP_RR -H ${NETPERF_SERVER} -- -r80000:80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT
