#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: gre-ipv6-ipv4
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2

    gre1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:1::1/64 dev eth1
      - ip addr add 10.1.5.10/24 dev eth2
      # P-to-P GRE Tunnel:
      - ip l a gre00 type gre local 10.1.5.10 remote 10.1.8.10
      - ip l s gre00 up
      - ip a a 1:1:1::1/64 dev gre00
     
      - ip r a 10:244:2::/64 via 1:1:1::2 dev gre00 onlink

      - ip route replace default via 10.1.5.1 dev eth2 

      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"

    gre2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:2::1/64 dev eth1
      - ip addr add 10.1.8.10/24 dev eth2

      - ip l a gre00 type gre local 10.1.8.10 remote 10.1.5.10
      - ip l s gre00 up
      - ip a a 1:1:1::2/64 dev gre00

      - ip r a 10:244:1::/64 via 1:1:1::1 dev gre00 onlink

      - ip route replace default via 10.1.8.1 dev eth2
      
      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"


    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10:244:1::10/64 dev net0
      - ip route replace default via 10:244:1::1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10:244:2::10/64 dev net0
      - ip route replace default via 10:244:2::1

  links:
    - endpoints: ["gre1:eth1", "server1:net0"]
      mtu: 1500
    - endpoints: ["gre2:eth1", "server2:net0"]
      mtu: 1500

    - endpoints: ["gre1:eth2", "gwx:net1"]
      mtu: 1500
    - endpoints: ["gre2:eth2", "gwx:net2"]
      mtu: 1500
EOF

