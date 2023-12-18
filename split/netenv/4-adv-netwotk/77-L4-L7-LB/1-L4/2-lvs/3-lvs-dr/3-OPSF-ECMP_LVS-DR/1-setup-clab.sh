#!/bin/bash
set -v

# topo:     
#                              |-----------------------|---LVS-DR[10.1.8.253/24](net1),10.1.8.254/24(VIP[lo])]
#                              |-----------------------|---RS1[10.1.8.10/24](net1),[10.1.8.254/24](VIP[lo](arp_announce and arp_ignore]))
# client---eth1(10.1.5.1/24)-Router-eth2(10.1.8.1/24)--|---RS2[10.1.8.11/24](net1),[10.1.8.254/24](VIP[lo](arp_announce and arp_ignore]))
#                              |-----------------------|---RS3[10.1.8.12/24](net1),[10.1.8.254/24](VIP[lo](arp_announce and arp_ignore]))

{ ip l s brl4lb down && brctl delbr brl4lb; } > /dev/null 2>&1
brctl addbr brl4lb;ip l s brl4lb up

{ ip l s ospf-br down && brctl delbr ospf-br; } > /dev/null 2>&1
brctl addbr ospf-br;ip l s ospf-br up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ospf-lvs-dr
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    brl4lb:
      kind: bridge

    ospf-br:
      kind: bridge

    router:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/router-boot.cfg:/opt/vyatta/etc/config/config.boot

    lvs-dr-lb1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      exec:
        - >
          bash -c '
          ip a a 10.1.8.253/24 dev eth1 &&
          ip a a 10.1.8.254/32 dev lo &&
          ip r r default via 10.1.8.1 dev eth1'
        - keepalived -D  -f /etc/keepalived/keepalived.conf
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/lvs-dr-lb1-boot.cfg:/opt/vyatta/etc/config/config.boot
        - ./keepalived/keepalived1/keepalived.cfg:/etc/keepalived/keepalived.conf

    lvs-dr-lb2:
      kind: linux
      cmd: /sbin/init
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      exec:
        - >
          bash -c '
          ip a a 10.1.8.252/24 dev eth1 &&
          ip a a 10.1.8.254/32 dev lo &&
          ip r r default via 10.1.8.1 dev eth1'
        - keepalived -D  -f /etc/keepalived/keepalived.conf
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/lvs-dr-lb2-boot.cfg:/opt/vyatta/etc/config/config.boot
        - ./keepalived/keepalived2/keepalived.cfg:/etc/keepalived/keepalived.conf

    dr-rs1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.10/24 dev net1
      - ip a a 10.1.8.254/32 dev lo
      - ip r r default via 10.1.8.1 dev net1
      - >
        sh -c '
        bash -c "echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore" && bash -c "echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce" &&
        bash -c "echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore" && bash -c "echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce"'
          

    dr-rs2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.11/24 dev net1
      - ip a a 10.1.8.254/32 dev lo
      - ip r r default via 10.1.8.1 dev net1
      - >
        sh -c '
        bash -c "echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore" && bash -c "echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce" &&
        bash -c "echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore" && bash -c "echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce"'

    client:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.5/24 dev net1
      - ip r r default via 10.1.5.1
      - bash -c 'echo "10.1.5.1 www.wluo.com" >> /etc/hosts'

  links:
    - endpoints: ["client:net1", "router:eth1"]
    - endpoints: ["router:eth2", "ospf-br:net1"]
    - endpoints: ["lvs-dr-lb1:eth1", "ospf-br:net2"]
    - endpoints: ["lvs-dr-lb2:eth1", "ospf-br:net3"]
    - endpoints: ["dr-rs1:net1", "brl4lb:net4"]
    - endpoints: ["dr-rs2:net1", "brl4lb:net5"]
EOF

