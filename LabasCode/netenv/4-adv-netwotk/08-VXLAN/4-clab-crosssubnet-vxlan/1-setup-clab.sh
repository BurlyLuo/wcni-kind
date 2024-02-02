#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vxlan
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx.cfg:/opt/vyatta/etc/config/config.boot

    vtep1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/vtep1.cfg:/opt/vyatta/etc/config/config.boot

    vtep2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/vtep2.cfg:/opt/vyatta/etc/config/config.boot

    vtep3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/vtep3.cfg:/opt/vyatta/etc/config/config.boot

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.1.10/24 dev net0
      - ip route replace default via 10.244.1.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.2.10/24 dev net0
      - ip route replace default via 10.244.2.1

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.3.10/24 dev net0
      - ip route replace default via 10.244.3.1

  links: 
    # vtep1:eth1 10.244.1.1 vtep1:eth2 10.1.5.10
    # vtep2:eth1 10.244.2.1 vtep2:eth2 10.1.8.10
    # vtep3:eth1 10.244.3.1 vtep3:eth2 10.1.9.10
    - endpoints: ["vtep1:eth1", "server1:net0"]
    - endpoints: ["vtep2:eth1", "server2:net0"]
    - endpoints: ["vtep3:eth1", "server3:net0"]
    # gwx:eth1 10.1.5.1
    # gwx:eth2 10.1.8.1
    # gwx:eth3 10.1.9.1
    - endpoints: ["vtep1:eth2", "gwx:eth1"]
    - endpoints: ["vtep2:eth2", "gwx:eth2"]
    - endpoints: ["vtep3:eth2", "gwx:eth3"]

EOF

