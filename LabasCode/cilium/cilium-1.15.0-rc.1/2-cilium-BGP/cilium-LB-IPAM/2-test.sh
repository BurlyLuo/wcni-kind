#/bin/bash
set -v 
kubectl get svc -o wide 
svc_ip=$(kubectl get svc service-lb-ipam -o jsonpath='{.status.loadBalancer.ingress}' | jq -r '.[0].ip')
echo $svc_ip
# even share the same subnet for the host. but still can not reachable to the service due to the leak of the L2-Aware-LB caps.[so LB-IPAM + L2-Aware-LB=MetalLB L2]
curl --connect-timeout 2 $svc_ip
