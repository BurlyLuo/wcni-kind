!/bin/bash
set -v

kubectl delete ds flannel-host-gw

kubectl delete svc serversvc

