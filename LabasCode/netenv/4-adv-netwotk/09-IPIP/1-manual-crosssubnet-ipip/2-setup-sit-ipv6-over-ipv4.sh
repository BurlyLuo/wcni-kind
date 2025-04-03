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

    ipip1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # add [node-gw] interface:eth1,eth2
      - ip a a 10:244:1::1/64 dev eth1
      - ip addr add 10.1.5.10/24 dev eth2

      # add ipip tunnel[lcoal 10.1.5.10 remote any.]
      - ip tunnel a ipip0 mode sit local 10.1.5.10 remote 10.1.8.10
      - ip a a 1:1:1::1/128 dev ipip0
      - ip l s ipip0 up

      # replace [node-gw] default gateway
      - ip route replace default via 10.1.5.1 dev eth2

      # add dst_routing table
      - ip r a 10:244:2::/64 via 1:1:1::2 dev ipip0 onlink
     
      # ipv6 forward
      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"

    ipip2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:2::1/64 dev eth1
      - ip addr add 10.1.8.10/24 dev eth2

      - ip tunnel a ipip0 mode sit local 10.1.8.10 remote 10.1.5.10
      - ip a a 1:1:1::2/128 dev ipip0
      - ip l s ipip0 up

      - ip route replace default via 10.1.8.1 dev eth2

      - ip r a 10:244:1::/64 via 1:1:1::1 dev ipip0 onlink

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
    - endpoints: ["ipip1:eth1", "server1:net0"]
      mtu: 1500
    - endpoints: ["ipip2:eth1", "server2:net0"]
      mtu: 1500
    - endpoints: ["ipip1:eth2", "gwx:net1"]
      mtu: 1500
    - endpoints: ["ipip2:eth2", "gwx:net2"]
      mtu: 1500
EOF

