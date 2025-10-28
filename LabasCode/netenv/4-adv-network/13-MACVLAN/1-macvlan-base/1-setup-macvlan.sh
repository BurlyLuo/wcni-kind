#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: macvlan
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gwx-boot.cfg:/opt/vyatta/etc/config/config.boot

    macvlan1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # MTU: https://www.cni.dev/plugins/current/main/macvlan/#network-configuration-reference
      # N-S Traffic:
        - >
          bash -c '
          ip l s net1 promisc on &&
          ip l s net1 mtu 1400 &&

          ip l a l net1 name macvlan1 type macvlan mode bridge &&
          ip l s macvlan1 up &&
          ip a a 10.1.5.10/24 dev macvlan1 &&
          
          ip route add 0.0.0.0/0 via 10.1.5.1 table 5 &&
          ip rule add from 10.1.5.0/24 table 5'
 
    macvlan2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic:
        - >
          bash -c '
          ip l s net1 promisc on &&
          ip l s net1 mtu 1400 &&

          ip l a l net1 name macvlan1 type macvlan mode bridge &&
          ip l s macvlan1 up &&
          ip a a 10.1.8.10/24 dev macvlan1 &&
          
          ip route add 0.0.0.0/0 via 10.1.8.1 table 8 &&
          ip rule add from 10.1.8.0/24 table 8'

    macvlan3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic:
        - >
          bash -c '
          ip l s net1 promisc on &&
          ip l s net1 mtu 1400 &&
 
          ip l a l net1 name macvlan1 type macvlan mode bridge &&
          ip l s macvlan1 up &&
          ip a a 10.1.9.10/24 dev macvlan1 &&
          
          ip route add 0.0.0.0/0 via 10.1.9.1 table 9 &&
          ip rule add from 10.1.9.0/24 table 9'

  links:
    - endpoints: ["macvlan1:net1", "gwx:eth1"]
    - endpoints: ["macvlan2:net1", "gwx:eth2"]
    - endpoints: ["macvlan3:net1", "gwx:eth3"]
    
EOF

