#!/bin/bash
set -v

cat <<EOF
1. Block ip address: HEX:0A16296C. 10.22.41.108
iptables -A INPUT -m string --hex-string "|0A16296C|" --algo bm --to 65535 -j DROP

2. Block dns NAPTR SRV A rec
NAPTR rec:
iptables -A INPUT -p udp --dport 53 -m string --hex-string "|00230001|" --algo bm --to 65535 -j DROP

SRV rec:
iptables -A INPUT -p udp --dport 53 -m string --hex-string "|00210001|" --algo bm --to 65535 -j DROP

A rec:
iptables -A INPUT -p udp --dport 53 -m string --hex-string "|00010001|" --algo bm --to 65535 -j DROP
EOF

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-match-string
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
      # block string: Host: 10.1.8.10\r\n
      - iptables -A FORWARD -m string --hex-string "|0a01080a|" --algo bm --to 65535 -j DROP

    client:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r r default via 10.1.5.1 dev net0

    server:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r r default via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "client:net0"]
    - endpoints: ["gw1:eth2", "server:net0"]

EOF
