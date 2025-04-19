#!/bin/bash
set -v
# topo:
#           10.1.5.1/24   10.1.8.1/24
#        1.1.12.1/.2/24   1.1.23.1/.2/24
#                gw1---gw2---gw3
# gre1:10.10.10.2/24         gre1:10.10.10.3/24

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ospf-gre-diff
topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw1.cfg:/opt/vyatta/etc/config/config.boot

    gw2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw2.cfg:/opt/vyatta/etc/config/config.boot

    gw3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw3.cfg:/opt/vyatta/etc/config/config.boot

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
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1


  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw3:eth1", "server2:net0"]

    - endpoints: ["gw1:eth2", "gw2:eth1"]
    - endpoints: ["gw2:eth2", "gw3:eth2"]

EOF

