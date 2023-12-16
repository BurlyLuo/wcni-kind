#!/bin/bash
set -v

# topo:    
#                                                           ---RS1[10.1.8.10/24]
#                               L4LB                        |
# client---eth1(10.1.5.1/24)-LVS[Server]-eth2(10.1.8.1/24)--|--RS2[10.1.8.11/24] 
#                                                           |
#                                                           ---RS3[10.1.8.12/24]


{ ip l s brl4lb down && brctl delbr brl4lb; } > /dev/null 2>&1
brctl addbr brl4lb;ip l s brl4lb up

modprobe iptable_nat

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: lvs-nat
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    brl4lb:
      kind: bridge

    lvs-nat-lb:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
        - >
          bash -c '
          ip a a 10.1.5.1/24 dev net1 &&
          ip a a 10.1.8.1/24 dev net2 &&
          bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward" &&
          ipvsadm -A -t 10.1.5.1:8080 -s rr &&
          ipvsadm -a -t 10.1.5.1:8080 -r 10.1.8.10:80 -m &&
          ipvsadm -a -t 10.1.5.1:8080 -r 10.1.8.11:80 -m &&
          ipvsadm -a -t 10.1.5.1:8080 -r 10.1.8.12:80 -m &&
          ipvsadm-save'

    nat-rs1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.10/24 dev net1
      - ip r r default via 10.1.8.1 dev net1

    nat-rs2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.11/24 dev net1
      - ip r r default via 10.1.8.1 dev net1


    nat-rs3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.12/24 dev net1
      - ip r r default via 10.1.8.1 dev net1

    client:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.5/24 dev net1
      - ip r r default via 10.1.5.1
      - bash -c 'echo "10.1.5.1 www.wluo.com" >> /etc/hosts'

  links:
    - endpoints: ["lvs-nat-lb:net2", "brl4lb:net1"]
    - endpoints: ["nat-rs1:net1", "brl4lb:net2"]
    - endpoints: ["nat-rs2:net1", "brl4lb:net3"]
    - endpoints: ["nat-rs3:net1", "brl4lb:net4"]
    - endpoints: ["client:net1", "lvs-nat-lb:net1"]
EOF

