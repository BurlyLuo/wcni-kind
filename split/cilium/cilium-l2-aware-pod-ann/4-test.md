



1. pod ip root@2204:~/wcni-kind/split/cilium/cilium-ipv46-big-tcp/kindenv# k get pods -owide 
NAME         READY   STATUS    RESTARTS   AGE   IP           NODE                                       NOMINATED NODE   READINESS GATES
wluo-lt65f   1/1     Running   0          4s    10.0.0.70    cilium-l2-aware-lb-pod-ann-control-plane   <none>           <none>
root@2204:~/wcni-kind/split/cilium/cilium-ipv46-big-tcp/kindenv# 

2. root@cilium-l2-aware-lb-pod-ann-control-plane:~# tcpdump -pne -i eth0 arp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
11:27:58.017491 02:42:ac:12:00:04 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Reply 10.0.0.70 is-at 02:42:ac:12:00:04, length 46

3. GARP packet
11:27:58.017491 02:42:ac:12:00:04 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Reply 10.0.0.70 is-at 02:42:ac:12:00:04, length 46

4. if disable the feature. we can see there is no GARP sent
root@cilium-socket-lb-control-plane:~# tcpdump -pne -i eth0 arp 
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C
0 packets captured
0 packets received by filter
0 packets dropped by kernel
root@cilium-socket-lb-control-plane:~#


