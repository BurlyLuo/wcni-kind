#/bin/bash
set -v
# 1. http gateway-api test 
GATEWAY=$(kubectl get gateway my-gateway -o jsonpath='{.status.addresses[0].value}')
curl -v http://"$GATEWAY"/details/1 | jq
