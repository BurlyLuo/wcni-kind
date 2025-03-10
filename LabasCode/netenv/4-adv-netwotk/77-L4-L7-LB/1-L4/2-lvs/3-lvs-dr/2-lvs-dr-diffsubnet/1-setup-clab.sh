#!/bin/bash
set -v

# topo:     
#                              |--------------------------|---LVS-DR[10.1.8.253/24](net1),10.1.9.254/24(VIP[lo])]
#                              |--------------------------|---RS1[10.1.8.10/24](net1),[10.1.9.254/24](VIP[lo](arp_announce and arp_ignore]))
# client---eth1(10.1.5.1/24)-Router-eth2(10.1.8(9).1/24)--|---RS2[10.1.8.11/24](net1),[10.1.9.254/24](VIP[lo](arp_announce and arp_ignore]))
#                              |--------------------------|---RS3[10.1.8.12/24](net1),[10.1.9.254/24](VIP[lo](arp_announce and arp_ignore]))


{ ip l s brl4lb down && brctl delbr brl4lb; } > /dev/null 2>&1
brctl addbr brl4lb;ip l s brl4lb up

modprobe iptable_nat
lsmod | grep ip_vs

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: lvs-dr
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    brl4lb:
      kind: bridge

    router:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2
      - ip a a 10.1.9.1/24 dev net2
      - sh -c 'bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"'

    lvs-dr-lb:
      kind: linux
      image: 192.168.2.100:5000/xcni
      # tcpdump -pne -i net1 <> {Request who-has 10.1.9.254 tell 10.1.9.1,Reply 10.1.9.254 is-at aa:c1:ab:0e:60:96. [All other real-dr-rsx ignore ARP request]}
      exec:
        - >
          bash -c '
          ip a a 10.1.8.253/24 dev net1 &&
          ip a a 10.1.9.254/32 dev lo &&
          ip r r default via 10.1.8.1 dev net1 &&
          bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward" &&
          ipvsadm -A -t 10.1.9.254:80 -s rr &&
          ipvsadm -a -t 10.1.9.254:80 -r 10.1.8.10:80 -g &&
          ipvsadm -a -t 10.1.9.254:80 -r 10.1.8.11:80 -g &&
          ipvsadm -a -t 10.1.9.254:80 -r 10.1.8.12:80 -g &&
          ipvsadm-save'

    dr-rs1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.10/24 dev net1
      - ip a a 10.1.9.254/32 dev lo
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
      - ip a a 10.1.9.254/32 dev lo
      - ip r r default via 10.1.8.1 dev net1
      - >
        sh -c '
        bash -c "echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore" && bash -c "echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce" &&
        bash -c "echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore" && bash -c "echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce"'


    dr-rs3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.12/24 dev net1
      - ip a a 10.1.9.254/32 dev lo
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
      - bash -c 'echo "10.1.9.254 www.wluo.com" >> /etc/hosts'

  links:
    - endpoints: ["router:net2", "brl4lb:net1"]
    - endpoints: ["lvs-dr-lb:net1", "brl4lb:net2"]
    - endpoints: ["dr-rs1:net1", "brl4lb:net3"]
    - endpoints: ["dr-rs2:net1", "brl4lb:net4"]
    - endpoints: ["dr-rs3:net1", "brl4lb:net5"]
    - endpoints: ["client:net1", "router:net1"]
EOF

