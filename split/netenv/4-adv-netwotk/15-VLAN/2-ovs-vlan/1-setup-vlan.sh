#!/bin/bash
set -v
{ ip l s vswitch0 down && ovs-vsctl del-br vswitch0; } > /dev/null 2>&1
ovs-vsctl add-br vswitch0;ip l s vswitch0 up

{ ip l s vswitch1 down && ovs-vsctl del-br vswitch1; } > /dev/null 2>&1
ovs-vsctl add-br vswitch1;ip l s vswitch1 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vlan
topology:
  nodes:
    vswitch0:
      kind: ovs-bridge

    vswitch1:
      kind: ovs-bridge

    gwx:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx-boot.cfg:/opt/vyatta/etc/config/config.boot

    vlan1:
      kind: linux
      image: 192.168.2.100:5000/nettool

    vlan2:
      kind: linux
      image: 192.168.2.100:5000/nettool
    
    vlan3:
      kind: linux
      image: 192.168.2.100:5000/nettool

    vlan4:
      kind: linux
      image: 192.168.2.100:5000/nettool

  links:
    #- endpoints: ["vlan1:net1", "vswitch0:vlan-ovs-5-1"]
    #- endpoints: ["vlan2:net1", "vswitch1:vlan-ovs-5-2"]
    #- endpoints: ["vlan3:net1", "vswitch0:vlan-ovs-8-1"]
    #- endpoints: ["vlan4:net1", "vswitch1:vlan-ovs-8-2"]

    - endpoints: ["vswitch0:net1", "gwx:eth1"]
    - endpoints: ["vswitch0:net2", "gwx:eth2"]

EOF

#ovs-vsctl add-port vswitch0 patch_to_vswitch1
#ovs-vsctl add-port vswitch1 patch_to_vswitch0
#ovs-vsctl set interface patch_to_vswitch1 type=patch
#ovs-vsctl set interface patch_to_vswitch0 type=patch
#ovs-vsctl set interface patch_to_vswitch0 options:peer=patch_to_vswitch1
#ovs-vsctl set interface patch_to_vswitch1 options:peer=patch_to_vswitch0

#

#ovs-vsctl set port patch_to_vswitch1 VLAN_mode=trunk
#ovs-vsctl set port patch_to_vswitch0 VLAN_mode=trunk
#ovs-vsctl set port patch_to_vswitch0 trunk=5
#ovs-vsctl set port patch_to_vswitch1 trunk=8
#ovs-vsctl set port patch_to_vswitch0 trunk=5
#ovs-vsctl set port patch_to_vswitch1 trunk=8






docker run -t -i -d --name clab-vlan-vlan1 --net=none --privileged 192.168.2.100:5000/nettool
docker run -t -i -d --name clab-vlan-vlan2 --net=none --privileged 192.168.2.100:5000/nettool
docker run -t -i -d --name clab-vlan-vlan3 --net=none --privileged 192.168.2.100:5000/nettool
docker run -t -i -d --name clab-vlan-vlan4 --net=none --privileged 192.168.2.100:5000/nettool


ovs-vsctl add-br vswitch0
ovs-vsctl add-br vswitch1



ovs-docker add-port vswitch0 eth0 clab-vlan-vlan1 --ipaddress=10.1.5.10/24
ovs-docker add-port vswitch1 eth0 clab-vlan-vlan2 --ipaddress=10.1.5.11/24
ovs-docker add-port vswitch0 eth0 clab-vlan-vlan3 --ipaddress=10.1.5.12/24
ovs-docker add-port vswitch1 eth0 clab-vlan-vlan4 --ipaddress=10.1.5.13/24


ovs-vsctl add-port vswitch0 patch_to_vswitch1
ovs-vsctl add-port vswitch1 patch_to_vswitch0
ovs-vsctl set interface patch_to_vswitch1 type=patch
ovs-vsctl set interface patch_to_vswitch0 type=patch
ovs-vsctl set interface patch_to_vswitch0 options:peer=patch_to_vswitch1
ovs-vsctl set interface patch_to_vswitch1 options:peer=patch_to_vswitch0



ovs-vsctl set port patch_to_vswitch1 VLAN_mode=trunk
ovs-vsctl set port patch_to_vswitch0 VLAN_mode=trunk
ovs-vsctl set port patch_to_vswitch0 trunk=5
ovs-vsctl set port patch_to_vswitch1 trunk=5
ovs-vsctl set port patch_to_vswitch0 trunk=5
ovs-vsctl set port patch_to_vswitch1 trunk=5


ovs-vsctl set port 9aee5ff5870c4_l tag=5
ovs-vsctl set port 48f443cd4a484_l tag=5
ovs-vsctl set port 1177b891a9244_l tag=5
ovs-vsctl set port 9f75b889966e4_l tag=5


ovs-vsctl set port patch_to_vswitch1 VLAN_mode=trunk
ovs-vsctl set port patch_to_vswitch0 VLAN_mode=trunk
ovs-vsctl set port patch_to_vswitch0 trunk=5
ovs-vsctl set port patch_to_vswitch1 trunk=5
ovs-vsctl set port patch_to_vswitch0 trunk=8
ovs-vsctl set port patch_to_vswitch1 trunk=8


