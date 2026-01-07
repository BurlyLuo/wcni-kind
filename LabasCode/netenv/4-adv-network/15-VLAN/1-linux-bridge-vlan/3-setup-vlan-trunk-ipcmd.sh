#!/bin/bash
set -v
{ ip l s br-vlan down && brctl delbr br-vlan; } > /dev/null 2>&1
brctl addbr br-vlan;ip l s br-vlan up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vlan
topology:
  nodes:
    br-vlan581:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
         - /lib/modules:/lib/modules
      exec:
        - modprobe 8021q
        - ip link add name br-trunk type bridge
        - ip link set br-trunk up 
        - ip link set br-trunk type bridge vlan_filtering 1
        - ip link set net581 master br-trunk
        - ip link set net1 master br-trunk
        - ip link set net2 master br-trunk
        - bridge vlan add dev net581 vid 5
        - bridge vlan add dev net1 vid 5 
        - bridge vlan add dev net581 vid 8
        - bridge vlan add dev net2 vid 8

    br-vlan582:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
         - /lib/modules:/lib/modules
      exec:
        - modprobe 8021q 
        - ip link add name br-trunk type bridge
        - ip link set br-trunk up 
        - ip link set br-trunk type bridge vlan_filtering 1
        - ip link set net582 master br-trunk 
        - ip link set net1 master br-trunk
        - ip link set net2 master br-trunk		
        - bridge vlan add dev net582 vid 5
        - bridge vlan add dev net1 vid 5 
        - bridge vlan add dev net582 vid 8
        - bridge vlan add dev net2 vid 8

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # N-S Traffic:
        - >
          bash -c '
          ip l a name net1.5 link net1 type vlan id 5 &&
          ip l s net1.5 up &&
          ip a a 10.1.5.10/24 dev net1.5 &&
          ip r r default via 10.1.5.1 dev net1.5'
 
    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic:
        - >
          bash -c '
          ip l a name net1.8 link net1 type vlan id 8  &&
          ip l s net1.8 up &&
          ip a a 10.1.8.10/24 dev net1.8 &&
          ip r r default via 10.1.8.1 dev net1.8'

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic:
        - >
          bash -c '
          ip l a name net1.5 link net1 type vlan id 5 &&
          ip l s net1.5 up &&
          ip a a 10.1.5.11/24 dev net1.5 &&
          ip r r default via 10.1.5.1 dev net1.5'

    server4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic[vlan 9 internal]:
        - >
          bash -c '
          ip l a name net1.8 link net1 type vlan id 8 &&
          ip l s net1.8 up &&
          ip a a 10.1.8.11/24 dev net1.8 &&
          ip r r default via 10.1.8.1 dev net1.8'


  links:
    - endpoints: ["server1:net1", "br-vlan581:net1"]
    - endpoints: ["server2:net1", "br-vlan581:net2"]
    - endpoints: ["server3:net1", "br-vlan582:net1"]
    - endpoints: ["server4:net1", "br-vlan582:net2"]
    
    - endpoints: ["br-vlan581:net581", "br-vlan582:net582"]
EOF
