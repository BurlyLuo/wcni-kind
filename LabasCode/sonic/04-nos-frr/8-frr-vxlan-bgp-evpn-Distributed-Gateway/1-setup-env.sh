#!/bin/bash
set -v
for bridge in frrbr; do
    ip l s $bridge down >/dev/null 2>&1
    ip l d $bridge >/dev/null 2>&1
    ip l a $bridge type bridge
    ip l s $bridge up
done

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    frrbr:
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
        - ip link add br10 type bridge
        - ip link add vxlan10 type vxlan id 10 local 1.1.1.11 dstport 4789 nolearning
        - ip link set br10 up
        - ip link set eth2 up
        - ip link set vxlan10 up
        - ip link set eth2 master br10
        - ip link set vxlan10 master br10
        - ip a a 10.1.5.254/24 dev br10
        - ip link set dev br10 address 00:00:01:01:05:fe
        # l3 vni
        - ip link add br100 type bridge
        - ip link add vxlan100 type vxlan id 100 local 1.1.1.11 dstport 4789 nolearning
        - ip link set br100 up
        - ip link set vxlan100 up
        - ip link set vxlan100 master br100
        - ip link set dev br100 address 00:00:01:01:05:64
        # add vrf
        - ip link add evpn-vrf type vrf table 100
        - ip link set evpn-vrf up
        - ip link set br100 master evpn-vrf
        - ip link set br10 master evpn-vrf

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
        # for subnet 10.1.8.0/24
        - ip link add br20 type bridge
        - ip link set br20 up
        - ip link set eth2 up
        - ip link set eth2 master br20
        - ip addr add 10.1.8.254/24 dev br20
        # for subnet 10.1.5.0/24
        - ip link add br10 type bridge
        - ip link add vxlan10 type vxlan id 10 local 1.1.1.12 dstport 4789 nolearning
        - ip link set vxlan10 up
        - ip link set vxlan10 master br10
        - ip link set br10 up
        - ip link set eth3 up
        - ip link set eth3 master br10
        - ip addr add 10.1.5.254/24 dev br10
        - ip link set dev br10 address 00:00:01:01:05:fe
        # l3 vni
        - ip link add br100 type bridge
        - ip link add vxlan100 type vxlan id 100 local 1.1.1.12 dstport 4789 nolearning
        - ip link set br100 up
        - ip link set vxlan100 up
        - ip link set vxlan100 master br100
        - ip link set dev br100 address 00:00:01:02:03:64
        # add vrf
        - ip link add evpn-vrf type vrf table 100
        - ip link set evpn-vrf up
        - ip link set br100 master evpn-vrf
        - ip link set br20 master evpn-vrf
        - ip link set br10 master evpn-vrf


    vm1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.5.10/24 dev eth1
        - ip link set dev eth1 address 52:54:10:01:05:10
        - ip r r default via 10.1.5.254

    vm2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.8.10/24 dev eth1
        - ip link set dev eth1 address 52:54:10:01:08:10
        - ip r r default via 10.1.8.254

    vm3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.5.11/24 dev eth1
        - ip link set dev eth1 address 52:54:10:01:05:11
        - ip r r default via 10.1.5.254        


  links:
    - endpoints: ["spine1:eth1", "frrbr:xth1"]
    - endpoints: ["leaf1:eth1", "frrbr:xth2"]
    - endpoints: ["leaf2:eth1", "frrbr:xth3"]
    - endpoints: ["leaf1:eth2", "vm1:eth1"]
    - endpoints: ["leaf2:eth2", "vm2:eth1"]
    - endpoints: ["leaf2:eth3", "vm3:eth1"]
EOF
