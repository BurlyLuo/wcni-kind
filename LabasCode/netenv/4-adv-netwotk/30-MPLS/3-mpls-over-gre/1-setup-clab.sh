#!/bin/bash
set -v

# GRE:
#tunnel_ip:1.1.1.1/24 tunnel_ip:1.1.1.2/24
#    172.12.1.10/.11   172.23.1.10/.11
#   gre1    ---    gre2    ---    gre3 
#   /                               \
#10.1.5.10                        10.1.8.10
# tunnel_ip: 仅仅是配置地址，但是实际上用不上，在配置路由的时候指定的还是接口：set protocols static route 10.1.8.0/24 interface tun0

# MPLS with GRE
# MPLS在VPN中的应用，用MPLS为转发通道运行私网流量，使一个运营商的网络可以同时支撑多个不同客户的IP VPN，这样就要求运营商的网络全程支持MPLS转发。但是在实际运用中，有时由于网络规划的原因，运营商网络的中间设备并不支持MPLS功能，而基本的BGP/MPLS VPN是要求所用到的运营商设备全程支持MPLS功能才可以，这样采用基本的BGP/MPLS VPN方法就行不通了，此时GRE的应用很好的解决了这个问题，只需要运营商边缘设备支持MPLS转发就能实现功能。而且GRE只需要保证两端网络类型相同，中间可以穿越其他类型的网络，也降低了对运营商网络的要求

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: mpls-gre
topology:
  nodes:
    r1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/mpls-gre1.cfg:/opt/vyatta/etc/config/config.boot

    r2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/mpls-gre2.cfg:/opt/vyatta/etc/config/config.boot

    r3:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/mpls-gre3.cfg:/opt/vyatta/etc/config/config.boot

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
    - endpoints: ["r1:eth1", "server1:net0"]
    - endpoints: ["r3:eth1", "server2:net0"]

    - endpoints: ["r1:eth2", "r2:eth1"]
    - endpoints: ["r2:eth2", "r3:eth2"]

EOF

