#!/bin/bash
date
set -v 

# 1. wait pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all

# 2. add both dst route
kubectl exec -it ipvlanl3-pod1 -- ip r d 15.1.2.0/24 dev eth1 > /dev/null 2>&1 &
kubectl exec -it ipvlanl3-pod2 -- ip r d 15.1.1.0/24 dev eth1 > /dev/null 2>&1 &
sleep 1
kubectl exec -it ipvlanl3-pod1 -- ip r a 15.1.2.0/24 dev eth1
kubectl exec -it ipvlanl3-pod2 -- ip r a 15.1.1.0/24 dev eth1

# 3. ping test
pod1_eth1_ip=`kubectl exec -it ipvlanl3-pod1 -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
pod2_eth1_ip=`kubectl exec -it ipvlanl3-pod2 -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
kubectl exec -it ipvlanl3-pod1 -- tcpdump -pne -i eth1 -c 1 icmp & > /dev/null 2>&1 &
sleep 2
kubectl exec -it ipvlanl3-pod1 -- bash -c "ping -c 1 $pod2_eth1_ip -I $pod1_eth1_ip"

kubectl exec -it ipvlanl3-pod1 -- bash -c "route -n"

