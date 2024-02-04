#/bin/bash
set -v

# 1. http gateway-api test 
GATEWAY=$(kubectl get gateway my-gateway -o jsonpath='{.status.addresses[0].value}')
curl -v http://"$GATEWAY"/details/1 | jq

# node_name=$(docker ps -a --format "table {{.Names}}" | grep cilium-gwapi-http | grep control-plane)
# docker exec -it $node_name tcpdump -pne -c 2 -i eth0 host $GATEWAY & > /dev/null 2>&1 &

