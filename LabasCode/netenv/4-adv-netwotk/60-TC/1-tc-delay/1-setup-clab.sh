#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tc-delay
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

      - ip a a 1.1.1.1/24 dev eth2
      - ip r a 10.1.8.0/24 via 1.1.1.2 dev eth2
     
      - tc qdisc add dev eth1 root netem delay 500ms

    gw2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.8.1/24 dev eth1

      - ip a a 1.1.1.2/24 dev eth2
      - ip r a 10.1.5.0/24 via 1.1.1.1 dev eth2     

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1

  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw2:eth1", "server2:net0"]
    - endpoints: ["gw1:eth2", "gw2:eth2"]

EOF

