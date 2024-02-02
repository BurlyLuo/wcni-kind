#!/bin/bash
set -v

{ ip l s brl4lb down && brctl delbr brl4lb; } > /dev/null 2>&1
brctl addbr brl4lb;ip l s brl4lb up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: lvs-ospf
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    brl4lb:
      kind: bridge

    gw1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw1-boot.cfg:/opt/vyatta/etc/config/config.boot

    gw2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw2-boot.cfg:/opt/vyatta/etc/config/config.boot

    gw3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw3-boot.cfg:/opt/vyatta/etc/config/config.boot

  links:
    - endpoints: ["gw1:eth1", "brl4lb:net1"]
    - endpoints: ["gw2:eth1", "brl4lb:net2"]
    - endpoints: ["gw3:eth1", "brl4lb:net3"]

EOF

