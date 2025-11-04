#!/bin/bash
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: clos-ai
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

    leaf3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/leaf3-boot.cfg:/opt/vyatta/etc/config/config.boot

    leaf4:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/leaf4-boot.cfg:/opt/vyatta/etc/config/config.boot

    leaf1-gpu1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.11.1/31 dev eth1
      - ip route replace default via 10.1.11.0

    leaf1-gpu2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.12.1/31 dev eth1
      - ip route replace default via 10.1.12.0

    leaf2-gpu1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.21.1/31 dev eth1
      - ip route replace default via 10.1.21.0

    leaf2-gpu2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.22.1/31 dev eth1
      - ip route replace default via 10.1.22.0

    leaf3-gpu1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.31.1/31 dev eth1
      - ip route replace default via 10.1.31.0

    leaf3-gpu2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.32.1/31 dev eth1
      - ip route replace default via 10.1.32.0

    leaf4-gpu1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.41.1/31 dev eth1
      - ip route replace default via 10.1.41.0

    leaf4-gpu2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.42.1/31 dev eth1
      - ip route replace default via 10.1.42.0

  links:
    # spine1 to leaf1
    - endpoints: ["spine1:eth1", "leaf1:eth1"]
      mtu: 9000
    # spine1 to leaf2
    - endpoints: ["spine1:eth2", "leaf2:eth1"]
      mtu: 9000
    # spine1 to leaf3
    - endpoints: ["spine1:eth3", "leaf3:eth1"]
      mtu: 9000
    # spine1 to leaf4
    - endpoints: ["spine1:eth4", "leaf4:eth1"]
      mtu: 9000

    # spine2 to leaf1
    - endpoints: ["spine2:eth1", "leaf1:eth2"]
      mtu: 9000
    # spine2 to leaf2
    - endpoints: ["spine2:eth2", "leaf2:eth2"]
      mtu: 9000
    # spine2 to leaf3
    - endpoints: ["spine2:eth3", "leaf3:eth2"]
      mtu: 9000
    # spine2 to leaf4
    - endpoints: ["spine2:eth4", "leaf4:eth2"]
      mtu: 9000

    # leaf1 to leaf1-gpu1
    - endpoints: ["leaf1:eth3", "leaf1-gpu1:eth1"]
      mtu: 9000
    # leaf1 to leaf1-gpu2
    - endpoints: ["leaf1:eth4", "leaf1-gpu2:eth1"]
      mtu: 9000

    # leaf2 to leaf2-gpu1
    - endpoints: ["leaf2:eth3", "leaf2-gpu1:eth1"]
      mtu: 9000
    # leaf2 to leaf2-gpu2
    - endpoints: ["leaf2:eth4", "leaf2-gpu2:eth1"]
      mtu: 9000

    # leaf3 to leaf3-gpu1
    - endpoints: ["leaf3:eth3", "leaf3-gpu1:eth1"]
      mtu: 9000
    # leaf3 to leaf3-gpu2
    - endpoints: ["leaf3:eth4", "leaf3-gpu2:eth1"]
      mtu: 9000

    # leaf4 to leaf4-gpu1
    - endpoints: ["leaf4:eth3", "leaf4-gpu1:eth1"]
      mtu: 9000
    # leaf4 to leaf4-gpu2
    - endpoints: ["leaf4:eth4", "leaf4-gpu2:eth1"]
      mtu: 9000
EOF
