#!/bin/bash
set -v

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vxlan
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2
      - ip a a 10.1.9.1/24 dev net3

    vtep1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.1.1/24 dev eth1

      - ip addr add 10.1.5.10/24 dev eth2
      - ip l a vxlan0 type vxlan id 5 dstport 4789 local 10.1.5.10 dev eth2
      - ip a a 10.244.1.0/32 dev vxlan0
      - ip l s vxlan0 up
      - ip link set dev vxlan0 address 02:42:8f:11:22:10

      - ip route replace default via 10.1.5.1 dev eth2 

      - ip r a 10.244.2.0/24 via 10.1.8.10 dev vxlan0 onlink
      - ip r a 10.244.3.0/24 via 10.1.9.10 dev vxlan0 onlink
      # [vxlan based on mac, but ipip based on ip. that's the key.]
      #- arp -s 10.244.2.0 02:42:8f:11:22:20 -i vxlan0
      #- arp -s 10.244.3.0 02:42:8f:11:22:30 -i vxlan0  

      - bridge fdb add 02:42:8f:11:22:20 dev vxlan0 dst 10.1.8.10 self permanent
      - bridge fdb add 02:42:8f:11:22:30 dev vxlan0 dst 10.1.9.10 self permanent

    vtep2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.2.1/24 dev eth1

      - ip addr add 10.1.8.10/24 dev eth2
      - ip l a vxlan0 type vxlan id 5 dstport 4789 local 10.1.8.10 dev eth2
      - ip a a 10.244.2.0/32 dev vxlan0
      - ip l s vxlan0 up
      - ip link set dev vxlan0 address 02:42:8f:11:22:20

      - ip route replace default via 10.1.8.1 dev eth2

      - ip r a 10.244.1.0/24 via 10.1.5.10 dev vxlan0 onlink
      - ip r a 10.244.3.0/24 via 10.1.9.10 dev vxlan0 onlink
      #- arp -s 10.244.1.0 02:42:8f:11:22:10 -i vxlan0
      #- arp -s 10.244.3.0 02:42:8f:11:22:30 -i vxlan0
       
      - bridge fdb add 02:42:8f:11:22:10 dev vxlan0 dst 10.1.5.10 self permanent
      - bridge fdb add 02:42:8f:11:22:30 dev vxlan0 dst 10.1.9.10 self permanent

    vtep3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.3.1/24 dev eth1

      - ip addr add 10.1.9.10/24 dev eth2
      - ip l a vxlan0 type vxlan id 5 dstport 4789 local 10.1.9.10 dev eth2
      - ip a a 10.244.3.0/32 dev vxlan0
      - ip l s vxlan0 up
      - ip link set dev vxlan0 address 02:42:8f:11:22:30

      - ip route replace default via 10.1.9.1 dev eth2

      - ip r a 10.244.1.0/24 via 10.1.5.10 dev vxlan0 onlink
      - ip r a 10.244.2.0/24 via 10.1.8.10 dev vxlan0 onlink
      #- arp -s 10.244.1.0 02:42:8f:11:22:10 -i vxlan0
      #- arp -s 10.244.2.0 02:42:8f:11:22:20 -i vxlan0

      - bridge fdb add 02:42:8f:11:22:10 dev vxlan0 dst 10.1.5.10 self permanent
      - bridge fdb add 02:42:8f:11:22:20 dev vxlan0 dst 10.1.8.10 self permanent


    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.1.10/24 dev net0
      - ip route replace default via 10.244.1.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.2.10/24 dev net0
      - ip route replace default via 10.244.2.1

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.3.10/24 dev net0
      - ip route replace default via 10.244.3.1

  links:
    - endpoints: ["vtep1:eth1", "server1:net0"]
    - endpoints: ["vtep2:eth1", "server2:net0"]
    - endpoints: ["vtep3:eth1", "server3:net0"]
    - endpoints: ["vtep1:eth2", "gwx:net1"]
    - endpoints: ["vtep2:eth2", "gwx:net2"]
    - endpoints: ["vtep3:eth2", "gwx:net3"]
    
EOF

