#!/bin/bash
set -v
lb_ip=`kubectl -nsandbox get svc --no-headers | grep ingress-nginx-controller | grep LoadBalancer | awk -F  " " '{print $4}'`
sed -i '/http-example.foo.com/d' /etc/hosts > /dev/null

echo $lb_ip http-example.foo.com >> /etc/hosts

# while true;do curl -kv https://https-example.foo.com;sleep 1;done


curl -k http://http-example.foo.com

