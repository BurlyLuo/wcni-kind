#!/bin/bash
set -v

for br in br0; do
    ip l s $br down > /dev/null 2>&1
    ip l d $br
    ip l a $br type bridge
    ip l s $br up
done

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: mptcp-metric
topology:
  nodes:
    br0:
      kind: bridge

    gw:
      kind: linux
      image: 192.168.2.100:5000/ucni
      exec:
      - ip addr add 10.1.5.1/24 dev net1
      - ip addr add 10.1.8.1/24 dev net1
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    client:
      kind: linux
      image: 192.168.2.100:5000/ucni
      exec:
      - ip addr add 10.1.5.10/24 dev net1
      - ip addr add 10.1.8.10/24 dev net2

      - ip r a default via 10.1.5.1 dev net1 metric 5

      - ip r a default via 10.1.8.1 dev net2 metric 8

      - ip mptcp endpoint add 10.1.5.10 id 5 dev net1 subflow
      - ip mptcp endpoint add 10.1.8.10 id 8 dev net2 subflow

      # mptcpize run curl https://check.mptcp.dev/
      
  links:
    - endpoints: ["br0:net1", "client:net1"]
    - endpoints: ["br0:net2", "client:net2"]
    - endpoints: ["gw:net1", "br0:net3"]
EOF
