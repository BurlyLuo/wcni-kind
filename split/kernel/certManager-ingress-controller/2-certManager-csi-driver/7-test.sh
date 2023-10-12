#!/bin/bash
kubectl -n sandbox get pods -l app=sample-api-client -o name | xargs -I{} kubectl -n sandbox exec {} -- curl -s https://sample-api-service --cacert /etc/tls/ca.crt

echo "no ca provide"

kubectl -n sandbox get pods -l app=sample-api-client -o name | xargs -I{} kubectl -n sandbox exec {} -- curl -ks https://sample-api-service

