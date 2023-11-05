#!/bin/bash
set -v

{ ip l s br-ovs0 down && ovs-vsctl del-br br-ovs0; } > /dev/null 2>&1
ovs-vsctl add-br br-ovs0;ip l s br-ovs0 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ovs
topology:
  nodes:
    br-ovs0:
      kind: ovs-bridge

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev net0

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev net0

  links:
    - endpoints: ["br-ovs0:eth1", "server1:net0"]
    - endpoints: ["br-ovs0:eth2", "server2:net0"]

EOF

