#!/bin/bash
set -v
{ ip l s br-vrf down && brctl delbr br-vrf; } > /dev/null 2>&1
brctl addbr br-vrf;ip l s br-vrf up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vrf
topology:
  nodes:
    br-vrf:
      kind: bridge

    gwx:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx.cfg:/opt/vyatta/etc/config/config.boot

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1
    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev net0
      - ip route replace default via 10.1.5.1

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1


  links:
    - endpoints: ["gwx:eth1", "br-vrf:eth1"]
    - endpoints: ["br-vrf:eth2", "server1:net0"]
    - endpoints: ["br-vrf:eth3", "server2:net0"]
    - endpoints: ["gwx:eth2", "server3:net0"]

EOF

