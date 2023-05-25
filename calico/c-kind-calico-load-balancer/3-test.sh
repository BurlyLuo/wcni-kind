#!/bin/bash
set -v
kubectl apply -f cni.yaml

kubectl wait --timeout=45s --for=condition=Ready=true pods --all

lb_ip=`kubectl -ndefault get svc --no-headers | grep backend-svc | grep LoadBalancer | awk -F  " " '{print $4}'`
sed -i '/test-loadbalancer.com/d' /etc/hosts > /dev/null

echo $lb_ip test-loadbalancer.com >> /etc/hosts

while true;do curl test-loadbalancer.com;sleep 1;done

