#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ipvlan
topology:
  nodes:
    ipvlan1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - >
          bash -c '
          ip l s net1 promisc on &&
          ip l s net1 up &&

          ip l a name net1.5 link net1 type vlan id 5 &&
          ip l s net1.5 up &&

          ip l a l net1.5 name ipvlan1.5 type ipvlan mode l2 &&
          ip a a 10.1.5.10/24 dev ipvlan1.5 &&
          ip l s ipvlan1.5 up'

 
    ipvlan2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - >
          bash -c '
          ip l s net1 promisc on &&
          ip l s net1 up &&

          ip l a name net1.5 link net1 type vlan id 5 &&
          ip l s net1.5 up &&

          ip l a l net1.5 name ipvlan1.5 type ipvlan mode l2 &&
          ip a a 10.1.5.11/24 dev ipvlan1.5 &&
          ip l s ipvlan1.5 up'
          
  links:
    - endpoints: ["ipvlan1:net1", "ipvlan2:net1"]
EOF
