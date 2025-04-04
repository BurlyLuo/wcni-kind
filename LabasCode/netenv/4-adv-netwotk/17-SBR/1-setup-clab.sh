#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: sbr
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - ip a a 10.1.9.1/24 dev eth3
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    sbr1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # N-S Traffic:
        - >
          bash -c '
          ip l s net1 up &&
          ip a a 10.1.5.10/24 dev net1 &&
          
          ip route add 0.0.0.0/0 via 10.1.5.1 table 5 &&
          ip rule add from 10.1.5.0/24 table 5'
 
    sbr2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic:
        - >
          bash -c '
          ip l s net1 up &&
          ip a a 10.1.8.10/24 dev net1 &&
          
          ip route add 0.0.0.0/0 via 10.1.8.1 table 8 &&
          ip rule add from 10.1.8.0/24 table 8'

    sbr3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # E-W Traffic:
        - >
          bash -c '
          ip l s net1 up &&
          ip a a 10.1.9.10/24 dev net1 &&
          
          ip route add 0.0.0.0/0 via 10.1.9.1 table 9 &&
          ip rule add from 10.1.9.0/24 table 9'

  links:
    - endpoints: ["sbr1:net1", "gwx:eth1"]
      mtu: 1500
    - endpoints: ["sbr2:net1", "gwx:eth2"]
      mtu: 1500
    - endpoints: ["sbr3:net1", "gwx:eth3"]
      mtu: 1500
EOF

