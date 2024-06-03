#!/bin/bash
set -v

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: mpls-2nodes
topology:
  nodes:
    mpls1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/mpls1.cfg:/opt/vyatta/etc/config/config.boot

    mpls2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/mpls2.cfg:/opt/vyatta/etc/config/config.boot

  links:
    - endpoints: ["mpls1:eth1", "mpls2:eth1"]

EOF

