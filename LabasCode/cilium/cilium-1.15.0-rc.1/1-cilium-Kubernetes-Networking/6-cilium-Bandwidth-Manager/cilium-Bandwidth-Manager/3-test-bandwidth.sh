#!/bin/bash
set -v

kubectl get pods  netperf-server -o yaml | grep "kubernetes.io/egress-bandwidth" | grep -v annotations | awk '$1=$1'

NETPERF_SERVER_IP=$(kubectl get pod netperf-server -o jsonpath='{.status.podIP}')
echo $NETPERF_SERVER_IP

kubectl exec netperf-client -- netperf -t TCP_MAERTS -H "${NETPERF_SERVER_IP}"

kubectl -nkube-system exec -it ds/cilium -- cilium status | grep -i BandwidthManager

