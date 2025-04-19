#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tc-delay
topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 1.1.1.1/24 dev eth2
      - ip r a 10.1.8.0/24 via 1.1.1.2 dev eth2
     
      - tc qdisc add dev eth1 root netem delay 1500ms
      # - tc qdisc show dev eth1
      # - tc qdisc del dev eth1 root 

    gw2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.8.1/24 dev eth1
      - ip a a 1.1.1.2/24 dev eth2
      - ip r a 10.1.5.0/24 via 1.1.1.1 dev eth2     

    client:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1

    server:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1

  links:
    - endpoints: ["gw1:eth1", "client:net0"]
    - endpoints: ["gw2:eth1", "server:net0"]
    - endpoints: ["gw1:eth2", "gw2:eth2"]
EOF
