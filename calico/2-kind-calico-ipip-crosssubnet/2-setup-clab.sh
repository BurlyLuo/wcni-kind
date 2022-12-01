#!/bin/bash
set -v

brctl addbr br-pool0
ifconfig br-pool0 up

brctl addbr br-pool1
ifconfig br-pool1 up


cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: calico-ipip-crosssubnet
topology:
  nodes:
    gw0:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.2.8
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules


    br-pool0:
      kind: bridge
  
    br-pool1:
      kind: bridge


    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:control-plane
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:worker
      exec:
      - ip addr add 10.1.5.11/24 dev net0
      - ip route replace default via 10.1.5.1

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:worker2
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1

    server4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:worker3
      exec:
      - ip addr add 10.1.8.11/24 dev net0
      - ip route replace default via 10.1.8.1


  links:
    - endpoints: ["br-pool0:br-pool0-net0", "server1:net0"]
    - endpoints: ["br-pool0:br-pool0-net1", "server2:net0"]
    - endpoints: ["br-pool1:br-pool1-net0", "server3:net0"]
    - endpoints: ["br-pool1:br-pool1-net1", "server4:net0"]

    - endpoints: ["gw0:eth1", "br-pool0:br-pool0-net2"]
    - endpoints: ["gw0:eth2", "br-pool1:br-pool1-net2"]

EOF

