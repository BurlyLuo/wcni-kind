#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ipip6-ipv4-ipv6
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:1:5::1/64 dev net1
      - ip a a 10:1:8::1/64 dev net2
      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"

    ipip1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.1.1/24 dev eth1
      - ip addr add 10:1:5::10/64 dev eth2

      - ip l a ipip0 type ip6tnl local 10:1:5::10 remote 10:1:8::10
      - ip a a 10.244.1.0/32 dev ipip0
      - ip l s ipip0 up

      - ip -6 route replace default via 10:1:5::1 dev eth2 

      - ip r a 10.244.2.0/24 via 10.244.2.0 dev ipip0 onlink
      
      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"

    ipip2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.2.1/24 dev eth1
      - ip addr add 10:1:8::10/64 dev eth2

      - ip l a ipip0 type ip6tnl local 10:1:8::10 remote 10:1:5::10
      - ip a a 10.244.2.0/32 dev ipip0
      - ip l s ipip0 up

      - ip -6 route replace default via 10:1:8::1 dev eth2

      - ip r a 10.244.1.0/24 via 10.244.1.0 dev ipip0 onlink

      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.1.10/24 dev net0
      - ip route replace default via 10.244.1.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.2.10/24 dev net0
      - ip route replace default via 10.244.2.1

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
