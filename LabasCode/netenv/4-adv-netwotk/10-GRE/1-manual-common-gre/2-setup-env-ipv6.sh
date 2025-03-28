#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: gre-ipv6
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2
      - ip a a 10.1.9.1/24 dev net3

    gre1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:1::1/64 dev eth1
      - ip addr add 10.1.5.10/24 dev eth2

      - ip l a gre00 type gre local 10.1.5.10 remote 10.1.8.10
      - ip l s gre00 up
      - ip a a 1:1:1::1/64 dev gre00 onlink

      - ip l a gre01 type gre local 10.1.5.10 remote 10.1.9.10
      - ip l s gre01 up
      - ip r a 10:244:3::0/64 via 1:1:1::2 dev gre01 onlink

      - ip route replace default via 10.1.5.1 dev eth2 

    gre2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:2::1/64 dev eth1
      - ip addr add 10.1.8.10/24 dev eth2

      - ip l a gre00 type gre local 10.1.8.10 remote 10.1.5.10
      - ip l s gre00 up
      - ip r a 1:1:1::2/64 dev gre00 onlink

      - ip l a gre01 type gre local 10.1.8.10 remote 10.1.9.10
      - ip l s gre01 up
      - ip r a 1:1:1::1/64 dev gre01 onlink

      - ip route replace default via 10.1.8.1 dev eth2


    gre3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:3::1/64 dev eth1
      - ip addr add 10.1.9.10/24 dev eth2

      - ip l a gre00 type gre local 10.1.9.10 remote 10.1.5.10
      - ip l s gre00 up
      - ip r a 10:244:1::0/64 dev gre00 onlink

      - ip l a gre01 type gre local 10.1.9.10 remote 10.1.8.10
      - ip l s gre01 up
      - ip r a 10:244:2::0/64 dev gre01 onlink

      - ip route replace default via 10.1.9.1 dev eth2


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

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10:244:3::10/24 dev net0
      - ip route replace default via 10:244:3::1

  links:
    - endpoints: ["gre1:eth1", "server1:net0"]
    - endpoints: ["gre2:eth1", "server2:net0"]
    - endpoints: ["gre3:eth1", "server3:net0"]

    - endpoints: ["gre1:eth2", "gwx:net1"]
    - endpoints: ["gre2:eth2", "gwx:net2"]
    - endpoints: ["gre3:eth2", "gwx:net3"]
    
EOF

