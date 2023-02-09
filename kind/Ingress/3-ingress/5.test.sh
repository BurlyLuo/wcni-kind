#!/bin/bash
set -v
lb_ip=`kubectl -nsandbox get svc --no-headers | grep ingress-nginx-controller | grep LoadBalancer |awk -F  " " '{print $4}'`
sed -i '/https-example.foo.com/d' /etc/hosts > /dev/null

echo $lb_ip https-example.foo.com >> /etc/hosts

while true;do curl -k https://https-example.foo.com;sleep 1;done

