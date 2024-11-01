#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-syn-sent
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - iptables -A FORWARD -s 10.1.8.10 -d 10.1.5.10 -p tcp --tcp-flags SYN,ACK SYN,ACK -j DROP
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r r default via 10.1.5.1 dev net0

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r r default via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw1:eth2", "server2:net0"]

EOF

# 1. cmd:
# iptables -A FORWARD -s 10.1.8.10 -d 10.1.5.10 -p tcp --tcp-flags SYN,ACK SYN,ACK -j DROP

# 2. curl the dst ip:port
# [root@server1 /]# curl 10.1.8.10 
# ...  waiting...

# 3. monitor the netstat outputs[server1]
# while true;do netstat -apn | grep SYN;done
# tcp        0      1 10.1.5.10:37580         10.1.8.10:80            SYN_SENT    79888/curl          
# tcp        0      1 10.1.5.10:37580         10.1.8.10:80            SYN_SENT    79888/curl          
# tcp        0      1 10.1.5.10:37580         10.1.8.10:80            SYN_SENT    79888/curl          
# tcp        0      1 10.1.5.10:37580         10.1.8.10:80            SYN_SENT    79888/curl          
# tcp        0      1 10.1.5.10:37580         10.1.8.10:80            SYN_SENT    79888/curl

