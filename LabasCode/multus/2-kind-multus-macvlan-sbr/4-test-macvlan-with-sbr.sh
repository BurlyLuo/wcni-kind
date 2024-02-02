#!/bin/bash
date
set -v
# 1. ping test
# eth0
eth0_ip=`kubectl exec -it macvlan-sbr-pod1 -- ip address show dev eth0 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
kubectl exec -it macvlan-sbr-pod1 -- tcpdump -pne -i eth0 -c 1 icmp & > /dev/null 2>&1 &
sleep 2
kubectl exec -it macvlan-sbr-pod1 -- ping -c 1 114.114.114.114 -I $eth0_ip

# eth1
eth1_ip=`kubectl exec -it macvlan-sbr-pod1 -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
kubectl exec -it macvlan-sbr-pod1 -- tcpdump -pne -i eth1 -c 1 icmp & > /dev/null 2>&1 &
sleep 2
kubectl exec -it macvlan-sbr-pod1 -- ping -c 1 114.114.114.114 -I $eth1_ip

# eth2
eth2_ip=`kubectl exec -it macvlan-sbr-pod1 -- ip address show dev eth2 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
kubectl exec -it macvlan-sbr-pod1 -- tcpdump -pne -i eth2 -c 1 icmp & > /dev/null 2>&1 &
sleep 2
kubectl exec -it macvlan-sbr-pod1 -- ping -c 1 114.114.114.114 -I $eth2_ip

# 2. routing table and rule table
kubectl exec -it macvlan-sbr-pod1 -- route -n

kubectl exec -it macvlan-sbr-pod1 -- ip rule show | grep -E "100|101"

kubectl exec -it macvlan-sbr-pod1 -- ip r s t 100

kubectl exec -it macvlan-sbr-pod1 -- ip r s t 101

