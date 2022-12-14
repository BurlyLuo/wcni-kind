#!/bin/bash
set -v 
kubectl exec -it ipvlan-pod-sbr -- ifconfig -a

kubectl exec -it ipvlan-pod-sbr -- ip route add 0.0.0.0/0 via 172.18.0.1 table 100
kubectl exec -it ipvlan-pod-sbr -- ip rule add from 172.18.0.0/24 table 100

kubectl exec -it ipvlan-pod-sbr -- bash -c "ping -c 1 114.114.114.114 -I 172.18.0.200"

kubectl exec -it ipvlan-pod-sbr -- ip rule s
kubectl exec -it ipvlan-pod-sbr -- ip r s t 100
