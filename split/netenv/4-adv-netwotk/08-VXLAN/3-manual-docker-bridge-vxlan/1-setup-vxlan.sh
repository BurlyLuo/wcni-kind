#!/bin/bash
set -v

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vxlan
topology:
  nodes:
    vxlan-bridge
      kind: bridge

    linux1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev eth1

      - ip addr add 172.12.1.10/24 dev eth2
      - ip l a vxlan0 type vxlan id 5 dstport 4789 remote 172.12.1.11 local 172.12.1.10 dev eth2
      - ip l s vxlan0 up
      - brctl addif vxlan0 vxlan-bridge
      - ip r a 10.1.8.0/24 dev vxlan0

    linux2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.8.1/24 dev eth1

      - ip addr add 172.12.1.11/24 dev eth2
      - ip l a vxlan0 type vxlan id 5 dstport 4789 remote 172.12.1.10 local 172.12.1.11 dev eth2
      - ip l s vxlan0 up
      - 

      - ip r a 10.1.5.0/24 via 10.1.5.0 dev vxlan0 onlink
       
      #- bridge fdb add ae:1f:0f:6f:72:b5 dev vxlan0 dst 172.12.1.10 self permanent

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
    - endpoints: ["linux1:eth1", "server1:net0"]
    - endpoints: ["linux2:eth1", "server2:net0"]
    - endpoints: ["linux1:eth2", "linux2:eth2"]

EOF

