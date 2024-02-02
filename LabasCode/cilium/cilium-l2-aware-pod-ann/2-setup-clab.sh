#!/bin/bash
set -v

{ ip l s br-pool0 down;ip l d br-pool0; } > /dev/null 2>&1
ip l a br-pool0 type bridge && ip l s br-pool0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cilium-l2-aware-lb-pod-ann 
topology:
  nodes:
    br-pool0:
      kind: bridge

    client:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.0.5.10/16 dev eth1
   
    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-l2-aware-lb-pod-ann-control-plane

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-l2-aware-lb-pod-ann-worker

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-l2-aware-lb-pod-ann-worker2


  links:
    - endpoints: ["br-pool0:br-pool0-net0", "server1:eth1"]
    - endpoints: ["br-pool0:br-pool0-net1", "server2:eth1"]
    - endpoints: ["br-pool0:br-pool0-net2", "server3:eth1"]
    - endpoints: ["br-pool0:br-pool0-net3", "client:eth1"]

EOF

