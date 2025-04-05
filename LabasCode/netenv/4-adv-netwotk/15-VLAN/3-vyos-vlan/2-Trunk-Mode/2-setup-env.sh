#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: manual-vlan-trunk
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    br1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip link add br1 type bridge vlan_filtering 1
      - ip l s br1 up
      - ip l s eth1 master br1
      - ip l s eth2 master br1
      - ip l s eth3 master br1

      - bridge vlan add vid 5 dev eth1 pvid untagged
      - bridge vlan del vid 1 dev eth1

      - bridge vlan add vid 8 dev eth2 pvid untagged
      - bridge vlan del vid 1 dev eth2

      - bridge vlan add vid 5 dev eth3 tagged
      - bridge vlan add vid 8 dev eth3 tagged
      - bridge vlan del vid 1 dev eth3

    br2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip link add br2 type bridge vlan_filtering 1
      - ip l s br2 up
      - ip l s eth1 master br2
      - ip l s eth2 master br2
      - ip l s eth3 master br2

      - bridge vlan add vid 5 dev eth1 pvid untagged
      - bridge vlan del vid 1 dev eth1

      - bridge vlan add vid 8 dev eth2 pvid untagged
      - bridge vlan del vid 1 dev eth2

      - bridge vlan add vid 5 dev eth3 tagged
      - bridge vlan add vid 8 dev eth3 tagged
      - bridge vlan del vid 1 dev eth3

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

    server3:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.11/24 dev net0
      - ip route replace default via 10.1.5.1

    server4:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.11/24 dev net0
      - ip route replace default via 10.1.8.1


  links:
    - endpoints: ["br1:eth1", "server1:net0"]
    - endpoints: ["br1:eth2", "server2:net0"]
    - endpoints: ["br1:eth3", "br2:eth3"]
    - endpoints: ["br2:eth1", "server3:net0"] 
    - endpoints: ["br2:eth2", "server4:net0"]
EOF

