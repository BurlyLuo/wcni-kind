#!/bin/bash
set -v
#     10.1.2.1/.2  10.2.3.2/.3  10.3.4.3/.4  
#   mpls1  ---   mpls2  ---  mpls3  ---  mpls4
#     |            |           |           |
#10.0.0.1/32  10.0.0.2/32 10.0.0.3/32  10.0.0.4/32

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: mpls
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

    mpls3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/mpls3.cfg:/opt/vyatta/etc/config/config.boot

    mpls4:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/mpls4.cfg:/opt/vyatta/etc/config/config.boot

  links:
    - endpoints: ["mpls1:eth1", "mpls2:eth1"]
    - endpoints: ["mpls2:eth2", "mpls3:eth1"]
    - endpoints: ["mpls3:eth2", "mpls4:eth1"]

EOF

