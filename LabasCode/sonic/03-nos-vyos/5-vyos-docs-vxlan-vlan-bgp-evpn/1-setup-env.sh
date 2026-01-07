#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vxlan
topology:
  nodes:
    RR1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/RR1.cfg:/opt/vyatta/etc/config/config.boot

    RR2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/RR2.cfg:/opt/vyatta/etc/config/config.boot

    R1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/R1.cfg:/opt/vyatta/etc/config/config.boot

    R2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/R2.cfg:/opt/vyatta/etc/config/config.boot

    R3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/R3.cfg:/opt/vyatta/etc/config/config.boot

    brvlan581:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
         - /lib/modules:/lib/modules
      exec:
        - modprobe 8021q
        - ip link add name br-trunk type bridge
        - ip link set br-trunk up 
        - ip link set br-trunk type bridge vlan_filtering 1
        - ip link set net581 master br-trunk
        - ip link set eth1 master br-trunk
        - ip link set eth2 master br-trunk
        - bridge vlan add dev net581 vid 5
        - bridge vlan add dev eth1 vid 5 pvid untagged 
        - bridge vlan add dev net581 vid 8
        - bridge vlan add dev eth2 vid 8 pvid untagged

    brvlan582:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
         - /lib/modules:/lib/modules
      exec:
        - modprobe 8021q 
        - ip link add name br-trunk type bridge
        - ip link set br-trunk up 
        - ip link set br-trunk type bridge vlan_filtering 1
        - ip link set net582 master br-trunk 
        - ip link set eth1 master br-trunk
        - ip link set eth2 master br-trunk
        - bridge vlan add dev net582 vid 5
        - bridge vlan add dev eth1 vid 5 pvid untagged
        - bridge vlan add dev net582 vid 8
        - bridge vlan add dev eth2 vid 8 pvid untagged

    brvlan583:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
         - /lib/modules:/lib/modules
      exec:
        - modprobe 8021q
        - ip link add name br-trunk type bridge
        - ip link set br-trunk up
        - ip link set br-trunk type bridge vlan_filtering 1
        - ip link set net583 master br-trunk
        - ip link set eth1 master br-trunk
        - ip link set eth2 master br-trunk
        - bridge vlan add dev net583 vid 5
        - bridge vlan add dev eth1 vid 5 pvid untagged
        - bridge vlan add dev net583 vid 8
        - bridge vlan add dev eth2 vid 8 pvid untagged

    PC1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.1/24 dev eth1
      - ip link set dev eth1 address  52:54:10:01:05:01

    PC2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.2/24 dev eth1
      - ip link set dev eth1 address  52:54:10:01:05:02

    PC3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.3/24 dev eth1
      - ip link set dev eth1 address  52:54:10:01:05:03

    PC4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.1/24 dev eth1
      - ip link set dev eth1 address  52:54:10:01:08:01

    PC5:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.2/24 dev eth1
      - ip link set dev eth1 address  52:54:10:01:08:02

    PC6:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.3/24 dev eth1
      - ip link set dev eth1 address  52:54:10:01:08:03

  links:
    # RR1 <> R1
    # 172.29.1.0/31 <> 172.29.1.1/31
    - endpoints: ["RR1:eth1", "R1:eth1"]

    # RR1 <> R2
    # 172.29.1.2/31 <> 172.29.1.3/31
    - endpoints: ["RR1:eth2", "R2:eth1"]

    # RR1 <> R3
    # 172.29.1.4/31 <> 172.29.1.5/31
    - endpoints: ["RR1:eth3", "R3:eth1"]


    # RR2 <> R1
    # 172.29.2.0/31 <> 172.29.2.1/31
    - endpoints: ["RR2:eth1", "R1:eth2"]

    # RR2 <> R2
    # 172.29.2.2/31 <> 172.29.2.3/31
    - endpoints: ["RR2:eth2", "R2:eth2"]

    # RR2 <> R3
    # 172.29.2.4/31 <> 172.29.2.5/31
    - endpoints: ["RR2:eth3", "R3:eth2"]


    # R1 <> brvlan581
    # vlan 5 8  <> vlan 5 8
    - endpoints: ["R1:eth3", "brvlan581:net581"]

    # R2 <> brvlan582
    # vlan 5 8 <> vlan 5 8
    - endpoints: ["R2:eth3", "brvlan582:net582"]

    # R3 <> brvlan583
    # vlan 5 8 <> vlan 5 8
    - endpoints: ["R3:eth3", "brvlan583:net583"]

    # brvlan581 <> PC1
    # vlan 5 <> 10.1.5.1/24
    - endpoints: ["brvlan581:eth1", "PC1:eth1"]

    # brvlan582 <> PC2
    # vlan 5 <> 10.1.5.2/24
    - endpoints: ["brvlan582:eth1", "PC2:eth1"]

    # brvlan583 <> PC1
    # vlan 5 <> 10.1.5.3/24
    - endpoints: ["brvlan583:eth1", "PC3:eth1"]

    # brvlan581 <> PC4
    # vlan 8 <> 10.1.8.1/24
    - endpoints: ["brvlan581:eth2", "PC4:eth1"]

    # brvlan582 <> PC5
    # vlan 8 <> 10.1.8.2/24
    - endpoints: ["brvlan582:eth2", "PC5:eth1"]

    # brvlan583 <> PC6
    # vlan 8 <> 10.1.8.3/24
    - endpoints: ["brvlan583:eth2", "PC6:eth1"]
EOF
