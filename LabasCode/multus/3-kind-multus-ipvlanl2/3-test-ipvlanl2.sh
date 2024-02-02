#/bin/bash
date
set -v

# 1. wait pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all

# 2. ping test
ipvlan_pod1_eth1=`kubectl  exec -it ipvlan-pod1  -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
ipvlan_pod2_eth1=`kubectl  exec -it ipvlan-pod2  -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
ipvlan_pod_x_eth1=`kubectl exec -it ipvlan-pod-x -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`

# 2.1 ipvlan-pod1 <> ipvlan-pod2
kubectl exec -it ipvlan-pod1 -- tcpdump -pne -i eth1 -c 1 icmp & > /dev/null 2>&1 &
sleep 2

kubectl exec -it ipvlan-pod1 -- bash -c "ping -c 1 $ipvlan_pod2_eth1 -I $ipvlan_pod1_eth1"

# 2.2 ipvlan-pod1 <> ipvlan-pod-x
kubectl exec -it ipvlan-pod1 -- tcpdump -pne -i eth1 -c 1 icmp & > /dev/null 2>&1 &
sleep 2

kubectl exec -it ipvlan-pod1 -- bash -c "ping -c 1 $ipvlan_pod_x_eth1 -I $ipvlan_pod1_eth1"

# 3. routing table
kubectl exec -it ipvlan-pod1 -- route -n
