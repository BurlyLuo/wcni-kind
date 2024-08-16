#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: macvlan
topology:
  nodes:
    macvlan1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # MTU: https://www.cni.dev/plugins/current/main/macvlan/#network-configuration-reference
        - >
          bash -c '
          ip l s net1 promisc on &&
          ip l s net1 mtu 1400 &&

          ip l a name net1.5 link net1 type vlan id 5 &&
          ip l s net1.5 up &&

          ip l a l net1.5 name macvlan1.5 type macvlan mode bridge &&
          ip l s macvlan1.5 up &&
          ip a a 10.1.5.10/24 dev macvlan1.5'
 
    macvlan2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - >
          bash -c '
          ip l s net1 promisc on &&
          ip l s net1 mtu 1400 &&

          ip l a name net1.5 link net1 type vlan id 5 &&
          ip l s net1.5 up &&

          ip l a l net1.5 name macvlan1.5 type macvlan mode bridge &&
          ip l s macvlan1.5 up &&
          ip a a 10.1.5.11/24 dev macvlan1.5'

  links:
    - endpoints: ["macvlan1:net1", "macvlan2:net1"]
    
EOF

