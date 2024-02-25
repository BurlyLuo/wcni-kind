#!/bin/bash
set -v

{ ip l s br-pool0 down;ip l d br-pool0; } > /dev/null 2>&1
ip l a br-pool0 type bridge && ip l s br-pool0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cilium-host-firewall
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

    client:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 12.1.6.10/24 dev eth1
      - ip route replace default via 12.1.6.1
   
    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-host-firewall-control-plane
      exec:
      - ip addr add 12.1.5.10/24 dev eth1
      - ip route add 12.1.6.0/24 via 12.1.5.1 dev eth1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-host-firewall-worker
      exec:
      - ip addr add 12.1.5.11/24 dev eth1
      - ip route add 12.1.6.0/24 via 12.1.5.1 dev eth1

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-host-firewall-worker2
      exec:
      - ip addr add 12.1.5.12/24 dev eth1
      - ip route add 12.1.6.0/24 via 12.1.5.1 dev eth1


  links:
    - endpoints: ["br-pool0:br-pool0-net0", "server1:eth1"]
    - endpoints: ["br-pool0:br-pool0-net1", "server2:eth1"]
    - endpoints: ["br-pool0:br-pool0-net2", "server3:eth1"]

    - endpoints: ["gw0:eth1", "br-pool0:br-pool0-net3"]
    - endpoints: ["gw0:eth2", "client:eth1"]

EOF

