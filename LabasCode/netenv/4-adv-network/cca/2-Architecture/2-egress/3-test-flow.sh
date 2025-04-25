#!/bin/bash
set -v 

# labels set
kubectl get pods -owide --show-labels 
# policy set
kubectl get cnp l3-egress-rule -o jsonpath='{.spec}' | python -mjson.tool

# 1. match rules
client_dev_pod_ip=$(kubectl get pods -owide | grep client-dev | awk '{print $6}')
client_prod_pod_ip=$(kubectl get pods -owide | grep client-prod | awk '{print $6}')

kubectl exec -it client-dev -- curl -m 1 $client_prod_pod_ip

# 2. not match rules:
nettool_pod_ip=$(kubectl get pods -owide | grep nettool | awk '{print $6}')
kubectl exec -it client-dev -- curl -m 1 $nettool_pod_ip

