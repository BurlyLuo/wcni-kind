#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: mtu-9000
topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 172.18.0.2/24 dev eth2
      - ip r a 10.1.8.0/24 dev eth2 via 172.18.0.3
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    gw2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.1/24 dev eth1
      - ip a a 172.18.0.3/24 dev eth2
      - ip r a 10.1.5.0/24 dev eth2 via 172.18.0.2 
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1

  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
      mtu: 9000
    - endpoints: ["gw2:eth1", "server2:net0"]
      mtu: 9000
    - endpoints: ["gw1:eth2", "gw2:eth2"]
      mtu: 9000
EOF
