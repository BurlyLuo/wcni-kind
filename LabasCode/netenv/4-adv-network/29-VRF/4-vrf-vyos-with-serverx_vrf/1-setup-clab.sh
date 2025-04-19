#!/bin/bash
set -v
{ ip l s br-vrf down && brctl delbr br-vrf; } > /dev/null 2>&1
brctl addbr br-vrf;ip l s br-vrf up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vrf
topology:
  nodes:
    br-vrf:
      kind: bridge

    gwx:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx.cfg:/opt/vyatta/etc/config/config.boot

    server1:
      # VRF 5 table 500
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1
    server2:
      # VRF 501 table 501
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev net0
      - ip link add dev vrf501 type vrf table 501
      - ip link set vrf501 up
      - ip link set net0 master vrf501
      - ip route replace default via 10.1.5.1 dev net0 vrf vrf501

    server3:
      # VFR 8 table 800
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1

    server4:
      # VRF 8 table 800
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.7.10/24 dev net0
      - ip link add dev vrf8 type vrf table 800
      - ip link set vrf8 up
      - ip link set net0 master vrf8
      - ip route replace default via 10.1.7.1 dev net0 vrf vrf8

    server5:
      # No VRF(default vrf)
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.9.11/24 dev net0
      - ip route replace default via 10.1.9.1

  links:
    - endpoints: ["gwx:eth1", "br-vrf:eth1"]
    - endpoints: ["br-vrf:eth2", "server1:net0"]
    - endpoints: ["br-vrf:eth3", "server2:net0"]
    - endpoints: ["gwx:eth2", "server3:net0"]
    - endpoints: ["gwx:eth3", "server4:net0"]
    - endpoints: ["gwx:eth4", "server5:net0"]

EOF

