#!/bin/bash
date
set -v 

# 1. wait pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all

# 2. add sbr configuration
kubectl exec -it ipvlan-pod-sbr1 -- ip rule del table 1 > /dev/null 2>&1 &
kubectl exec -it ipvlan-pod-sbr1 -- ip route del 0.0.0.0/0 via 172.18.0.1 table 1 > /dev/null 2>&1 &
sleep 2
kubectl exec -it ipvlan-pod-sbr1 -- ip route add 0.0.0.0/0 via 172.18.0.1 table 1
kubectl exec -it ipvlan-pod-sbr1 -- ip rule add from 172.18.0.0/24 table 1

# 3. ping test
eth1_ip=`kubectl exec -it ipvlan-pod-sbr1 -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
kubectl exec -it ipvlan-pod-sbr1 -- tcpdump -pne -i eth1 -c 2 icmp & > /dev/null 2>&1 &
sleep 2
kubectl exec -it ipvlan-pod-sbr1 -- bash -c "ping -c 1 114.114.114.114 -I $eth1_ip"

