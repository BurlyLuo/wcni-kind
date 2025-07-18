#!/bin/bash
set -v
{ ip l s br-leaf0 down;brctl delbr br-leaf0;ip l s br-leaf1 down;brctl delbr br-leaf1; } > /dev/null 2>&1
brctl addbr br-leaf0;ip l s br-leaf0 up;brctl addbr br-leaf1;ip l s br-leaf1 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cilium-bgp
topology:
  nodes:
    spine0:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/spine0-boot.cfg:/opt/vyatta/etc/config/config.boot

    leaf0:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/leaf0-boot.cfg:/opt/vyatta/etc/config/config.boot

    br-leaf0:
      kind: bridge
  
    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-bgp-control-plane
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      network-mode: container:cilium-bgp-worker
      exec:
      - ip addr add 10.1.5.11/24 dev net0
      - ip route replace default via 10.1.5.1


  links:
    - endpoints: ["br-leaf0:br-leaf0-net0", "server1:net0"]
    - endpoints: ["br-leaf0:br-leaf0-net1", "server2:net0"]

    - endpoints: ["leaf0:eth1", "spine0:eth1"]
    - endpoints: ["leaf0:eth3", "br-leaf0:br-leaf0-net2"]

EOF
