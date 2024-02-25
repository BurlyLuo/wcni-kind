#!/bin/bash
set -v
{ ip l s br-pool0 down;ip l d br-pool0; } > /dev/null 2>&1
ip l a br-pool0 type bridge && ip l s br-pool0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cilium-egress-gateway
topology:
  nodes:
    firewall:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/firewall-boot.cfg:/opt/vyatta/etc/config/config.boot
 
    br-pool0:
      kind: bridge

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-egress-gateway-control-plane
      exec:
      - ip addr add 11.1.5.10/24 dev eth9

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-egress-gateway-worker
      exec:
      - ip addr add 11.1.5.11/24 dev eth9

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-egress-gateway-worker2
      exec:
      - ip addr add 11.1.5.12/24 dev eth9
      - ip route replace default via 11.1.5.1

    server4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-egress-gateway-worker3
      exec:
      - ip addr add 11.1.5.13/24 dev eth9
      - ip route replace default via 11.1.5.1

    ext-client:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 11.1.8.10/24 dev net0
      - ip route replace default via 11.1.8.1
   

  links:
    - endpoints: ["br-pool0:br-pool0-net0", "server1:eth9"]
    - endpoints: ["br-pool0:br-pool0-net1", "server2:eth9"]
    - endpoints: ["br-pool0:br-pool0-net2", "server3:eth9"]
    - endpoints: ["br-pool0:br-pool0-net3", "server4:eth9"]

    - endpoints: ["firewall:eth1", "br-pool0:br-pool0-net4"]

    - endpoints: ["firewall:eth2", "ext-client:net0"]

EOF
