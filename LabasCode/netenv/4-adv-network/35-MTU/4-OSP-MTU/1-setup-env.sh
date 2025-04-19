#!/bin/bash
set -v
{ ip l s br-pool0 down && brctl delbr br-pool0; } > /dev/null 2>&1
brctl addbr br-pool0;ip l s br-pool0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: veth
topology:
  nodes:
    br-pool0:
      kind: bridge

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev net0

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev net0

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.12/24 dev net0

    server4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.13/24 dev net0

  links:
    - endpoints: ["br-pool0:net1", "server1:net0"]
      mtu: 1500
    - endpoints: ["br-pool0:net2", "server2:net0"]
      mtu: 1500
    - endpoints: ["br-pool0:net3", "server3:net0"]
      mtu: 1500
    - endpoints: ["br-pool0:net4", "server4:net0"]
      mtu: 1500
EOF
