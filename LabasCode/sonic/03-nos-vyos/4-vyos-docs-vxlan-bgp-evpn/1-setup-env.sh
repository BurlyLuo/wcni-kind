#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
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


    # R1 <> PC1
    # n/a <> 10.1.5.1/24
    - endpoints: ["R1:eth3", "PC1:eth1"]

    # R2 <> PC2
    # n/a <> 10.1.5.2/24
    - endpoints: ["R2:eth3", "PC2:eth1"]

    # R3 <> PC3
    # n/a <> 10.1.5.3/24
    - endpoints: ["R3:eth3", "PC3:eth1"]
EOF
