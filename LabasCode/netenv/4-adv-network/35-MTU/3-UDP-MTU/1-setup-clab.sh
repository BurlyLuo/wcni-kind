#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: udp-mtu
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 1.1.1.1/24 dev eth2
      - ip l s eth2 mtu 1280
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

      - ip r a 10.1.8.0/24 via 1.1.1.2 dev eth2

    gw2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.1/24 dev eth1
      - ip a a 1.1.1.2/24 dev eth2
      - ip l s eth2 mtu 1280
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE 
      
      - ip r a 10.1.5.0/24 via 1.1.1.1 dev eth2

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev net0

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r a 10.1.5.0/24 via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw2:eth1", "server2:net0"]
    - endpoints: ["gw1:eth2", "gw2:eth2"]
EOF

