#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-port-num-resued
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw1-boot.cfg:/opt/vyatta/etc/config/config.boot

    gw2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw2-boot.cfg:/opt/vyatta/etc/config/config.boot

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev net0

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r a 10.1.5.0/24 via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw2:eth1", "server2:net0"]
    - endpoints: ["gw1:eth2", "gw2:eth2"]

EOF

# cmd:
# lo clab-tcp-port-num-resued-server1 bash ; yum -y install hping3 && hping3 -a 10.1.5.10 -s 12345 -S 10.1.8.10 -p 80 -c 1
# lo clab-tcp-port-num-resued-gw1 tcpdump -pne -i eth2 -w eth2.cap
