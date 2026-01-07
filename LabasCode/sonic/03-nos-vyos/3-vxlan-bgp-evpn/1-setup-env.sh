#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    spine1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/spine1-boot.cfg:/opt/vyatta/etc/config/config.boot

    spine2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/spine2-boot.cfg:/opt/vyatta/etc/config/config.boot

    leaf1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/leaf1-boot.cfg:/opt/vyatta/etc/config/config.boot

    leaf2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/leaf2-boot.cfg:/opt/vyatta/etc/config/config.boot

    # vlan 5 - 10.1.5.10/24
    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1
      - ip route replace default via 10.1.5.1

    # vlan 8 - 10.1.8.10/24
    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev eth1
      - ip route replace default via 10.1.8.1

    # vlan 5 - 10.1.5.11/24
    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev eth1
      - ip route replace default via 10.1.5.1

    # vlan 8 - 10.1.8.11/24
    server4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.11/24 dev eth1
      - ip route replace default via 10.1.8.1

  links:
    # spine1 <> leaf1
    # 10.1.10.2/24 <> 10.1.10.1/24
    - endpoints: ["spine1:eth1", "leaf1:eth1"]

    # spine1 <> leaf2
    # 10.1.34.2/24 <> 10.1.34.1/24
    - endpoints: ["spine1:eth2", "leaf2:eth1"]

    # spine2 <> leaf1
    # 10.1.12.2/24 <> 10.1.12.1/24 
    - endpoints: ["spine2:eth1", "leaf1:eth2"]

    # spine2 <> leaf2
    # 10.1.11.2/24 <> 10.1.11.1/24
    - endpoints: ["spine2:eth2", "leaf2:eth2"]

    # leaf1 <> server1
    # 10.1.5.10/24 vlan5
    - endpoints: ["leaf1:eth3", "server1:eth1"]

    # leaf1 <> server2
    # 10.1.8.10/24 vlan8
    - endpoints: ["leaf1:eth4", "server2:eth1"]

    # leaf2 <> server3
    # 10.1.5.11/24 vlan5
    - endpoints: ["leaf2:eth3", "server3:eth1"]

    # leaf2 <> server4
    # 10.1.8.11/24 vlan8
    - endpoints: ["leaf2:eth4", "server4:eth1"]
EOF
