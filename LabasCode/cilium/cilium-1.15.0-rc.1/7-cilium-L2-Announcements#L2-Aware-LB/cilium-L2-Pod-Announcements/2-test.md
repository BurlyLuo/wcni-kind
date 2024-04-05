1. root@cilium-l2-announcements-l2lb-pod-announcements-control-plane:/# tcpdump -pne -i eth0 arp

2. kubectl apply -f cni.yaml

3. garp list:
root@cilium-l2-announcements-l2lb-pod-announcements-control-plane:/# tcpdump -pne -i eth0 arp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
13:30:00.454530 02:42:ac:12:00:03 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Reply 10.0.1.4 is-at 02:42:ac:12:00:03, length 46
13:30:00.493911 02:42:ac:12:00:02 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Reply 10.0.2.220 is-at 02:42:ac:12:00:02, length 46
13:30:00.494299 02:42:ac:12:00:04 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Reply 10.0.0.20 is-at 02:42:ac:12:00:04, length 46
