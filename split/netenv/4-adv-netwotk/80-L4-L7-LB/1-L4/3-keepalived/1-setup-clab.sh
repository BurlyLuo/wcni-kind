#!/bin/bash
set -v

{ ip l s brl4 down && brctl delbr brl4; } > /dev/null 2>&1
brctl addbr brl4;ip l s brl4 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: l4lb
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    brl4:
      kind: bridge

    brl4l7:
      kind: bridge

    keepalived1:
      kind: linux
      image: 192.168.2.100:5000/keepalived:2.0.8
      exec:
      - ip a a 10.1.5.99/24 dev net1
      - keepalived -D  -f /etc/keepalived/keepalived.conf
      cmd: sleep infinity 
      binds:
        - ./keepalived/keepalived1/keepalived.conf:/etc/keepalived/keepalived.conf

    keepalived2:
      kind: linux
      image: 192.168.2.100:5000/keepalived:2.0.8
      cmd: sleep infinity
      exec:
      - ip a a 10.1.5.101/24 dev net1
      - keepalived -D  -f /etc/keepalived/keepalived.conf
      binds:
        - ./keepalived/keepalived2/keepalived.conf:/etc/keepalived/keepalived.conf

    haproxy1:
      kind: linux
      image: 192.168.2.100:5000/haproxy:1.5.18
      cmd: sleep infinity
      exec:
      - ip a a 10.1.5.200/24 dev net1
      - haproxy -f /etc/haproxy/haproxy.cfg
      binds:
        - ./haproxy/haproxy1/haproxy.cfg:/etc/haproxy/haproxy.cfg

    haproxy2:
      kind: linux
      image: 192.168.2.100:5000/haproxy:1.5.18
      cmd: sleep infinity
      exec:
      - ip a a 10.1.5.201/24 dev net1
      - haproxy -f /etc/haproxy/haproxy.cfg
      binds:
        - ./haproxy/haproxy2/haproxy.cfg:/etc/haproxy/haproxy.cfg


    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.11/24 dev net0
      - ip route replace default via 10.1.5.1


  links:
    - endpoints: ["server1:net0", "brl4:net1"]
    - endpoints: ["server2:net0", "brl4:net2"]
    - endpoints: ["keepalived1:net1", "brl4:net3"]
    - endpoints: ["keepalived2:net1", "brl4:net4"]

EOF

