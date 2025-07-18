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
kubectl exec -it ipvlan-pod-sbr1 -- ip rule add from 172.18.0.0/24 table 1 priority 42765

# 3. ping test
sbr1_eth1_ip=`kubectl exec -it ipvlan-pod-sbr1 -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
sbr2_eth1_ip=`kubectl exec -it ipvlan-pod-sbr2 -- ip address show dev eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1`
kubectl exec -it ipvlan-pod-sbr1 -- tcpdump -pne -i eth1 -c 2 icmp & > /dev/null 2>&1 &
sleep 3
kubectl exec -it ipvlan-pod-sbr1 -- bash -c "ping -c 1 $sbr2_eth1_ip -I $sbr1_eth1_ip"
# pod 初始部署出来的时候才能show出这个效果。

cat <<EOF
BUT!!!:
we can see: the following packet will use the real peer's mac to encap the packet.
[root@ipvlan-pod-sbr1 ~]# tcpdump -pne -i eth1
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
08:33:28.482140 02:42:ac:12:00:02 > 33:33:00:00:00:02, ethertype IPv6 (0x86dd), length 70: fe80::242:ac00:112:2 > ff02::2: ICMP6, router solicitation, length 16
08:33:32.839679 02:42:ac:12:00:02 > 02:42:14:dc:cd:40, ethertype IPv4 (0x0800), length 98: 172.18.0.200 > 172.18.0.201: ICMP echo request, id 83, seq 1, length 64
08:33:32.839774 02:42:ac:12:00:04 > 02:42:ac:12:00:02, ethertype IPv4 (0x0800), length 98: 172.18.0.201 > 172.18.0.200: ICMP echo reply, id 83, seq 1, length 64
08:33:33.854527 02:42:ac:12:00:02 > 02:42:14:dc:cd:40, ethertype IPv4 (0x0800), length 98: 172.18.0.200 > 172.18.0.201: ICMP echo request, id 83, seq 2, length 64
08:33:33.854602 02:42:14:dc:cd:40 > 02:42:ac:12:00:02, ethertype IPv4 (0x0800), length 126: 172.18.0.1 > 172.18.0.200: ICMP redirect 172.18.0.201 to host 172.18.0.201, length 92    // when recv this packet, we can see the dst_mac will be replaced with real peer's mac address.
08:33:33.854661 02:42:ac:12:00:04 > 02:42:ac:12:00:02, ethertype IPv4 (0x0800), length 98: 172.18.0.201 > 172.18.0.200: ICMP echo reply, id 83, seq 2, length 64
08:33:34.877727 02:42:ac:12:00:02 > 02:42:ac:12:00:04, ethertype IPv4 (0x0800), length 98: 172.18.0.200 > 172.18.0.201: ICMP echo request, id 83, seq 3, length 64
08:33:34.877803 02:42:ac:12:00:04 > 02:42:ac:12:00:02, ethertype IPv4 (0x0800), length 98: 172.18.0.201 > 172.18.0.200: ICMP echo reply, id 83, seq 3, length 64
EOF


