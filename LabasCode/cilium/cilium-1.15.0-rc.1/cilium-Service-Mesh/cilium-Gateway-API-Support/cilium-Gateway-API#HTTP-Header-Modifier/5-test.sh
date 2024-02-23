#!/bin/bash
GATEWAY=$(kubectl get gateway cilium-gw -o jsonpath='{.status.addresses[0].value}')
curl -s http://$GATEWAY/add-a-request-header | grep -A 6 "Request Headers"
