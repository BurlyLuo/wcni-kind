#!/bin/bash
set -v

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: bgp-base
topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw0.cfg:/opt/vyatta/etc/config/config.boot

    gw2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      exec:
      - sh -c 'tcpdump -pne -i eth2 -w eth2.cap &'
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw1.cfg:/opt/vyatta/etc/config/config.boot

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
    - endpoints: ["gw2:eth1", "server2:net0"]
    - endpoints: ["gw1:eth2", "gw2:eth2"]

EOF

