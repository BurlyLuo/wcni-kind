!/bin/bash
set -v

kubectl delete ds flannel-wireguard

kubectl delete svc serversvc

