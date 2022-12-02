!/bin/bash
set -v

kubectl delete ds flannel-ipip

kubectl delete svc serversvc

