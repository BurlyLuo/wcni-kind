#!/bin/bash
set -v

{ ip l s br-pool0 down;ip l d br-pool0; } > /dev/null 2>&1
ip l a br-pool0 type bridge && ip l s br-pool0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cni-multus
topology:
  nodes:
    gw0:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw0-boot.cfg:/opt/vyatta/etc/config/config.boot
 
    br-pool0:
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
    - endpoints: ["br-pool0:br-pool0-net0", "server1:net0"]
    - endpoints: ["br-pool0:br-pool0-net1", "server2:net0"]
    - endpoints: ["br-pool0:br-pool0-net2", "server3:net0"]

    - endpoints: ["gw0:eth1", "br-pool0:br-pool0-net3"]
EOF

