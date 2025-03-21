#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ipvlan
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx-boot.cfg:/opt/vyatta/etc/config/config.boot

    ipvlan1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # N-S Traffic:
        - >
          bash -c '
          ip l s net1 promisc on &&

          ip l a l net1 name ipvlan1 type ipvlan mode l2 &&
          ip l s ipvlan1 up &&
          ip a a 10.1.5.10/24 dev ipvlan1 &&
          
          ip route add 0.0.0.0/0 via 10.1.5.1 table 5 &&
          ip rule add from 10.1.5.0/24 table 5'
 
    ipvlan02:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic[L2 Mode]:
        - >
          bash -c '
          ip l s eth0 promisc on &&

          ip l a l eth0 name ipvlan1 type ipvlan mode l2 &&
          ip l s ipvlan1 up &&
          ip a a 10.1.7.10/24 dev ipvlan1'

    ipvlan20:
      kind: linux
      image: 192.168.2.100:5000/nettool
      # E-W Traffic[L2 Mode]:
      exec:
        - >
          bash -c '
          ip l s eth0 promisc on &&

          ip l a l eth0 name ipvlan2 type ipvlan mode l2 &&
          ip l s ipvlan2 up &&
          ip a a 10.1.7.11/24 dev ipvlan2'

    ipvlan03:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic[L3 Mode]:
        - >
          bash -c '
          ip l s eth0 promisc on &&

          ip netns add ns1 &&
          ip l a l eth0 name ipvlan1 type ipvlan mode l3 &&
          ip l s ipvlan1 netns ns1 &&
          ip netns exec ns1 ip l s ipvlan1 up &&
          ip netns exec ns1 ip a a 10.1.8.10/24 dev ipvlan1 &&
          ip netns exec ns1 ip r a default dev ipvlan1 &&
                                    	  
          ip netns add ns2 &&
          ip l a l eth0 name ipvlan1 type ipvlan mode l3 &&
          ip l s ipvlan1 netns ns2 &&
          ip netns exec ns2 ip l s ipvlan1 up &&
          ip netns exec ns2 ip a a 10.1.9.10/24 dev ipvlan1 &&
          ip netns exec ns2 ip r a default dev ipvlan1'

          
  links:
    - endpoints: ["ipvlan1:net1", "gwx:eth1"]
EOF

