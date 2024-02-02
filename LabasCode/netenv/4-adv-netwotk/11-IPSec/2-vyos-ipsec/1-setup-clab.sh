#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vyos-ipsec
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gwx1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx1-boot.cfg:/opt/vyatta/etc/config/config.boot

    br1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/br1-boot.cfg:/opt/vyatta/etc/config/config.boot
    br2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/br2-boot.cfg:/opt/vyatta/etc/config/config.boot

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1

    server3:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.11/24 dev net0
      - ip route replace default via 10.1.5.1

    server4:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.11/24 dev net0
      - ip route replace default via 10.1.8.1

    gwx:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx-boot.cfg:/opt/vyatta/etc/config/config.boot

    gwx2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx1-boot.cfg:/opt/vyatta/etc/config/config.boot

    br3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/br3-boot.cfg:/opt/vyatta/etc/config/config.boot
    br4:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/br4-boot.cfg:/opt/vyatta/etc/config/config.boot

    server5:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.20/24 dev net0
      - ip route replace default via 10.1.5.1

    server6:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.20/24 dev net0
      - ip route replace default via 10.1.8.1

    server7:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.21/24 dev net0
      - ip route replace default via 10.1.5.1

    server8:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.21/24 dev net0
      - ip route replace default via 10.1.8.1

  links:
    - endpoints: ["br1:net1", "server1:net0"]
    - endpoints: ["br1:net2", "server2:net0"]
    - endpoints: ["br1:net3", "br2:net3"]
    - endpoints: ["br2:net1", "server3:net0"]
    - endpoints: ["br2:net2", "server4:net0"]
    - endpoints: ["gwx1:eth1", "br1:eth4"]

    - endpoints: ["br3:net1", "server5:net0"]
    - endpoints: ["br3:net2", "server6:net0"]
    - endpoints: ["br3:net3", "br4:net3"]
    - endpoints: ["br4:net1", "server7:net0"]
    - endpoints: ["br4:net2", "server8:net0"]
    - endpoints: ["gwx2:eth1", "br3:net4"]

    - endpoints: ["gwx:eth1", "gwx1:eth2"]
    - endpoints: ["gwx:eth2", "gwx2:eth2"]
EOF
