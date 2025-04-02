#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ipip-ipv4
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2
      - ip a a 10.1.9.1/24 dev net3

    ipip1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # add [node-gw] interface:eth1,eth2
      - ip a a 10.244.1.1/24 dev eth1
      - ip addr add 10.1.5.10/24 dev eth2
      # add ipip tunnel[lcoal 10.1.5.10 remote any.]
      - ip l a ipip0 type ipip local 10.1.5.10 dev eth2
      - ip a a 10.244.1.0/32 dev ipip0
      - ip l s ipip0 up
      # replace [node-gw] default gateway
      - ip route replace default via 10.1.5.1 dev eth2 
      # add dst_routing table
      - ip r a 10.244.2.0/24 via 10.1.8.10 dev ipip0 onlink
      - ip r a 10.244.3.0/24 via 10.1.9.10 dev ipip0 onlink

    ipip2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.2.1/24 dev eth1
      - ip addr add 10.1.8.10/24 dev eth2

      - ip l a ipip0 type ipip local 10.1.8.10 dev eth2
      - ip a a 10.244.2.0/32 dev ipip0
      - ip l s ipip0 up

      - ip route replace default via 10.1.8.1 dev eth2

      - ip r a 10.244.1.0/24 via 10.1.5.10 dev ipip0 onlink
      - ip r a 10.244.3.0/24 via 10.1.9.10 dev ipip0 onlink

    ipip3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.3.1/24 dev eth1
      - ip addr add 10.1.9.10/24 dev eth2

      - ip l a ipip0 type ipip local 10.1.9.10 dev eth2
      - ip a a 10.244.3.0/32 dev ipip0
      - ip l s ipip0 up

      - ip route replace default via 10.1.9.1 dev eth2

      - ip r a 10.244.1.0/24 via 10.1.5.10 dev ipip0 onlink
      - ip r a 10.244.2.0/24 via 10.1.8.10 dev ipip0 onlink

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
      - ip addr add 10.244.3.10/24 dev net0
      - ip route replace default via 10.244.3.1

  links:
    - endpoints: ["ipip1:eth1", "server1:net0"]
    - endpoints: ["ipip2:eth1", "server2:net0"]
    - endpoints: ["ipip3:eth1", "server3:net0"]
    - endpoints: ["ipip1:eth2", "gwx:net1"]
    - endpoints: ["ipip2:eth2", "gwx:net2"]
    - endpoints: ["ipip3:eth2", "gwx:net3"]
    
EOF

