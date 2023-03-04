#!/bin/bash
set -v
kubectl get pods  netperf-server -o yaml | grep "kubernetes.io/egress-bandwidth" | grep -v annotations | awk '$1=$1'

NETPERF_SERVER_IP=$(kubectl get pod netperf-server -o jsonpath='{.status.podIP}')
echo $NETPERF_SERVER_IP

kubectl exec netperf-client -- while [ 1 ]; do iperf3 -c "${NETPERF_SERVER_IP}" -t 55 -R -i 5 -0 5;done


