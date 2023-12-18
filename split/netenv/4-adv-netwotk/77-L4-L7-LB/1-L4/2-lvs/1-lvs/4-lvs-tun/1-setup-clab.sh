#!/bin/bash
set -v

# topo:     
#                              
#                              |-------------------------------------------------------------------------------------|---RS1(10.1.8.10/24)[VIP:10.1.8.254/32]
# client[net1]---[net1](10.1.5.1/24)-Router-[net1](10.1.8.1/24)--[net1](VIP:10.1.8.254/24)[10.1.8.253(254)/24/32]LVS-|---RS2(10.1.8.11/24)[VIP:10.1.8.254/32]
#                              |-------------------------------------------------------------------------------------|---RS3(10.1.8.12/24)[VIP:10.1.8.254/32]


{ ip l s brl4lb down && brctl delbr brl4lb; } > /dev/null 2>&1
brctl addbr brl4lb;ip l s brl4lb up

modprobe ipip
modprobe tun
lsmod | grep ip_vs
lsmod | grep ipip

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: lvs-tunnel
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
      - sh -c 'bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"'

    lvs-tunnel-lb:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      # VIP:10.1.8.254/32 DIP:10.1.8.253/24
        - >
          bash -c '
          ip a a 10.1.8.253/24 dev net1 &&
          ip a a 10.1.8.254/32 dev tunl0 &&
          ip l s tunl0 up &&
          ip r r default via 10.1.8.1 dev net1 &&
          ipvsadm -A -t 10.1.8.254:80 -s rr &&
          ipvsadm -a -t 10.1.8.254:80 -r 10.1.8.10:80 -i &&
          ipvsadm -a -t 10.1.8.254:80 -r 10.1.8.11:80 -i &&
          ipvsadm -a -t 10.1.8.254:80 -r 10.1.8.12:80 -i &&
          ipvsadm-save'

    tunnel-rs1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.10/24 dev net1
      - ip a a 10.1.8.254/32 dev tunl0
      - ip l s tunl0 up
      - ip r r default via 10.1.8.1 dev net1
      - >
        sh -c '
        bash -c "echo 1 >/proc/sys/net/ipv4/conf/tunl0/arp_ignore" && bash -c "echo 2 >/proc/sys/net/ipv4/conf/tunl0/arp_announce" &&
        bash -c "echo 1 >/proc/sys/net/ipv4/conf/all/arp_ignore" && bash -c "echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce" &&
        bash -c "echo 0 >/proc/sys/net/ipv4/conf/tunl0/rp_filter" && bash -c "echo 0 >/proc/sys/net/ipv4/conf/all/rp_filter"'        

    tunnel-rs2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.11/24 dev net1
      - ip a a 10.1.8.254/32 dev tunl0
      - ip l s tunl0 up
      - ip r r default via 10.1.8.1 dev net1
      - >
        sh -c '
        bash -c "echo 1 >/proc/sys/net/ipv4/conf/tunl0/arp_ignore" && bash -c "echo 2 >/proc/sys/net/ipv4/conf/tunl0/arp_announce" &&
        bash -c "echo 1 >/proc/sys/net/ipv4/conf/all/arp_ignore" && bash -c "echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce" &&
        bash -c "echo 0 >/proc/sys/net/ipv4/conf/tunl0/rp_filter" && bash -c "echo 0 >/proc/sys/net/ipv4/conf/all/rp_filter"' 

    tunnel-rs3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.12/24 dev net1
      - ip a a 10.1.8.254/32 dev tunl0
      - ip l s tunl0 up
      - ip r r default via 10.1.8.1 dev net1
      - >
        sh -c '
        bash -c "echo 1 >/proc/sys/net/ipv4/conf/tunl0/arp_ignore" && bash -c "echo 2 >/proc/sys/net/ipv4/conf/tunl0/arp_announce" &&
        bash -c "echo 1 >/proc/sys/net/ipv4/conf/all/arp_ignore" && bash -c "echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce" &&
        bash -c "echo 0 >/proc/sys/net/ipv4/conf/tunl0/rp_filter" && bash -c "echo 0 >/proc/sys/net/ipv4/conf/all/rp_filter"' 

    client:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.5/24 dev net1
      - ip r r default via 10.1.5.1
      - bash -c 'echo "10.1.5.1 www.wluo.com" >> /etc/hosts'

  links:
    - endpoints: ["router:net2", "brl4lb:net1"]
    - endpoints: ["lvs-tunnel-lb:net1", "brl4lb:net2"]
    - endpoints: ["tunnel-rs1:net1", "brl4lb:net3"]
    - endpoints: ["tunnel-rs2:net1", "brl4lb:net4"]
    - endpoints: ["tunnel-rs3:net1", "brl4lb:net5"]
    - endpoints: ["client:net1", "router:net1"]
EOF

