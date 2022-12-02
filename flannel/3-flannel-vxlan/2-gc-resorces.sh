!/bin/bash
set -v

kubectl delete ds flannel-vxlan

kubectl delete svc serversvc

