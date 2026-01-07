#!/bin/bash
set -v
for bridge in frrbrx; do
    ip l s $bridge down >/dev/null 2>&1
    ip l d $bridge >/dev/null 2>&1
    ip l a $bridge type bridge
    ip l s $bridge up
done

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: l3-l2-evpn
prefix: ""

topology:
  nodes:
    frrbrx:
      kind: bridge
   
    spine1:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/spine1.conf:/etc/frr/frr.conf
      exec:
        - touch /etc/frr/vtysh.conf
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - ip a a 1.1.1.10/24 dev eth1


    leaf1:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/leaf1.conf:/etc/frr/frr.conf
      exec:
        - touch /etc/frr/vtysh.conf
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - ip a a 1.1.1.11/24 dev eth1 

        # for subnet 10.1.5.0/24
        - ip link add br5 type bridge vlan_filtering 1 vlan_default_pvid 0
        - ip l s br5 up
        - bridge vlan add dev br5 vid 5 self
        - ip link set dev br5 address 00:00:01:01:01:05

        - ip link add vxlan5 type vxlan id 5000 local 1.1.1.11 dstport 4789 nolearning
        - ip link set vxlan5 up
        - ip link set vxlan5 master br5
        - bridge vlan add dev vxlan5 vid 5

        - ip link set eth2 up
        - ip link set eth2 master br5
        - bridge vlan add dev eth2 vid 5 master

        - ip link add vlan5 link br5 type vlan id 5
        - ip l s vlan5 up
        - ip a a 10.1.5.254/24 dev vlan5


        # for subnet 10.1.8.0/24
        - ip link add br8 type bridge vlan_filtering 1 vlan_default_pvid 0
        - ip l s br8 up
        - bridge vlan add dev br8 vid 8 self
        - ip link set dev br8 address 00:00:01:01:01:08

        - ip link add vxlan8 type vxlan id 8000 local 1.1.1.11 dstport 4789 nolearning
        - ip link set vxlan8 up
        - ip link set vxlan8 master br8
        - bridge vlan add dev vxlan8 vid 8

        - ip link set eth3 up
        - ip link set eth3 master br8
        - bridge vlan add dev eth3 vid 8 master

        - ip link add vlan8 link br8 type vlan id 8
        - ip l s vlan8 up
        - ip a a 10.1.8.254/24 dev vlan8

        # l3 vni
        - ip link add br100 type bridge
        - ip link set br100 up
        - ip link add vxlan100 type vxlan id 100 local 1.1.1.11 dstport 4789 nolearning
        - ip link set vxlan100 up
        - ip link set vxlan100 master br100
        - ip link set dev br100 address 00:00:01:01:01:64

        # add vrf
        - ip link add evpn-vrf type vrf table 100
        - ip link set evpn-vrf up
        - ip link set vlan5 vrf evpn-vrf
        - ip link set vlan8 vrf evpn-vrf
        - ip link set br5 master evpn-vrf
        - ip link set br8 master evpn-vrf
        - ip link set br100 master evpn-vrf

    leaf2:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/leaf2.conf:/etc/frr/frr.conf
      exec:
        - touch /etc/frr/vtysh.conf
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - ip a a 1.1.1.12/24 dev eth1

        # for subnet 10.1.5.0/24
        - ip link add br5 type bridge vlan_filtering 1 vlan_default_pvid 0
        - ip l s br5 up
        - bridge vlan add dev br5 vid 5 self
        - ip link set dev br5 address 00:00:01:01:02:05

        - ip link add vxlan5 type vxlan id 5000 local 1.1.1.12 dstport 4789 nolearning
        - ip link set vxlan5 up
        - ip link set vxlan5 master br5
        - bridge vlan add dev vxlan5 vid 5

        - ip link set eth2 up
        - ip link set eth2 master br5
        - bridge vlan add dev eth2 vid 5 master

        - ip link add vlan5 link br5 type vlan id 5
        - ip l s vlan5 up
        - ip a a 10.1.5.254/24 dev vlan5


        # for subnet 10.1.8.0/24
        - ip link add br8 type bridge vlan_filtering 1 vlan_default_pvid 0
        - ip l s br8 up
        - bridge vlan add dev br8 vid 8 self
        - ip link set dev br8 address 00:00:01:01:02:08

        - ip link add vxlan8 type vxlan id 8000 local 1.1.1.12 dstport 4789 nolearning
        - ip link set vxlan8 up
        - ip link set vxlan8 master br8
        - bridge vlan add dev vxlan8 vid 8
        
        - ip link set eth3 up
        - ip link set eth3 master br8
        - bridge vlan add dev eth3 vid 8 master

        - ip link add vlan8 link br8 type vlan id 8
        - ip l s vlan8 up
        - ip a a 10.1.8.254/24 dev vlan8

        # l3 vni
        - ip link add br100 type bridge
        - ip link set br100 up
        - ip link add vxlan100 type vxlan id 100 local 1.1.1.12 dstport 4789 nolearning
        - ip link set vxlan100 up
        - ip link set vxlan100 master br100
        - ip link set dev br100 address 00:00:01:01:02:64

        # add vrf
        - ip link add evpn-vrf type vrf table 100
        - ip link set evpn-vrf up
        - ip link set vlan5 vrf evpn-vrf
        - ip link set vlan8 vrf evpn-vrf
        - ip link set br5 master evpn-vrf
        - ip link set br8 master evpn-vrf
        - ip link set br100 master evpn-vrf

    vm1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip link add link eth1 name eth1.5 type vlan id 5
        - ip link set eth1.5 up
        - ip addr add 10.1.5.10/24 dev eth1.5
        - ip link set dev eth1.5 address 52:54:10:01:05:10
        - ip r r default via 10.1.5.254

    vm2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip link add link eth1 name eth1.5 type vlan id 5
        - ip link set eth1.5 up
        - ip addr add 10.1.5.11/24 dev eth1.5
        - ip link set dev eth1.5 address 52:54:10:01:05:11
        - ip r r default via 10.1.5.254

    vm3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip link add link eth1 name eth1.8 type vlan id 8
        - ip link set eth1.8 up
        - ip addr add 10.1.8.10/24 dev eth1.8
        - ip link set dev eth1.8 address 52:54:10:01:08:10
        - ip r r default via 10.1.8.254

    vm4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip link add link eth1 name eth1.8 type vlan id 8
        - ip link set eth1.8 up
        - ip addr add 10.1.8.11/24 dev eth1.8
        - ip link set dev eth1.8 address 52:54:10:01:08:11
        - ip r r default via 10.1.8.254


  links:
    - endpoints: ["spine1:eth1", "frrbrx:xxth1"]
    - endpoints: ["leaf1:eth1", "frrbrx:xxth2"]
    - endpoints: ["leaf2:eth1", "frrbrx:xxth3"]

    # leaf1<>10.1.5.10/24
    - endpoints: ["leaf1:eth2", "vm1:eth1"]
    # leaf2<>10.1.5.11/24
    - endpoints: ["leaf2:eth2", "vm2:eth1"]
    # leaf2<>10.1.8.10/24
    - endpoints: ["leaf1:eth3", "vm3:eth1"]
    # leaf1<>10.1.8.11/24
    - endpoints: ["leaf2:eth3", "vm4:eth1"]
EOF
