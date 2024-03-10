#!/bin/bash
set -v

{ ip l s br-pool0 down;ip l d br-pool0; } > /dev/null 2>&1
ip l a br-pool0 type bridge && ip l s br-pool0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cni-multus
topology:
  nodes:
    br-pool0:
      kind: bridge

    br-pool1:
      kind: bridge

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cni-multus-control-plane

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cni-multus-worker

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cni-multus-worker2


  links:
    - endpoints: ["br-pool0:br-pool0-net0", "server1:net1"]
    - endpoints: ["br-pool0:br-pool0-net1", "server2:net1"]
    - endpoints: ["br-pool0:br-pool0-net2", "server3:net1"]
 
    - endpoints: ["br-pool1:br-pool0-net0", "server1:net2"]
    - endpoints: ["br-pool1:br-pool0-net1", "server2:net2"]
    - endpoints: ["br-pool1:br-pool0-net2", "server3:net2"]

EOF

