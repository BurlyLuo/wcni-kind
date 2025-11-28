#!/bin/bash
set -v

cat <<EOF>clab.yaml | clab deploy -d -t clab.yaml -
name: routing
topology:
  nodes:
    gw0:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw0-boot.cfg:/opt/vyatta/etc/config/config.boot

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
      env:
        COLUMNS: "130"
        LINES: "100"      

  links:
    - endpoints: ["gw0:eth1", "server1:net0"]
    - endpoints: ["gw0:eth2", "server2:net0"]

EOF

