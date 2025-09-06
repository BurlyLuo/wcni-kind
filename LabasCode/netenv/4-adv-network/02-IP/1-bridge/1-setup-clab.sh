#!/bin/bash
set -v

{ ip l s br-pool0 down && brctl delbr br-pool0; } > /dev/null 2>&1
brctl addbr br-pool0;ip l s br-pool0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: bridge
topology:
  nodes:
    br-pool0:
      kind: bridge

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.10/24 dev net0
      - ip -6 a a 10:1:5::10/64 dev net0
      - ip l s dev net0 address aa:c1:ab:00:00:10

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.11/24 dev net0
      - ip -6 a a 10:1:5::11/64 dev net0
      - ip l s dev net0 address aa:c1:ab:00:00:11


    server3:
      # 为了测试server1到server2的NS会不会被server3收到.
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 55.1.5.11/24 dev net0
      - ip -6 a a 55:1:5::11/64 dev net0
      - ip l s dev net0 address aa:c1:ab:00:00:55


  links:
    - endpoints: ["br-pool0:eth1", "server1:net0"]
    - endpoints: ["br-pool0:eth2", "server2:net0"]
    - endpoints: ["br-pool0:eth3", "server3:net0"]

EOF

