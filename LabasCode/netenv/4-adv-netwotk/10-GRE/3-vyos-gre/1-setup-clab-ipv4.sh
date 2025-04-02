#!/bin/bash
set -v
# topo:
#tunnel_ip:1.1.1.1/24 tunnel_ip:1.1.1.2/24
#    172.12.1.10/.11   172.23.1.10/.11
#   gre1    ---    gre2    ---    gre3 
#   /                               \
#10.1.5.10                        10.1.8.10
# tunnel_ip: 仅仅是配置地址，但是实际上用不上，在配置路由的时候指定的还是接口：set protocols static route 10.1.8.0/24 interface tun0

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: gre
topology:
  nodes:
    gre1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./ipv4-startup-conf/gre1.cfg:/opt/vyatta/etc/config/config.boot

    gre2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./ipv4-startup-conf/gre2.cfg:/opt/vyatta/etc/config/config.boot

    gre3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./ipv4-startup-conf/gre3.cfg:/opt/vyatta/etc/config/config.boot

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


  links:
    - endpoints: ["gre1:eth1", "server1:net0"]
    - endpoints: ["gre3:eth1", "server2:net0"]

    - endpoints: ["gre1:eth2", "gre2:eth1"]
    - endpoints: ["gre2:eth2", "gre3:eth2"]

EOF

