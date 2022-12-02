!/bin/bash
set -v

kubectl delete ds flannel-udp

kubectl delete svc serversvc

