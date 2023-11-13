#!/bin/bash
set -v

# topo:    
#                                        nginx
#          ---10.1.5.99/24-------------10.1.5.80
#          |                         /
# client---| keepalived 10.1.5.100/24  
#          |                         \
#          ---10.1.5.98/24-------------10.1.5.90
#                                        nginx

{ ip l s brl4 down && brctl delbr brl4; } > /dev/null 2>&1
brctl addbr brl4;ip l s brl4 up

{ ip l s brl4l7 down && brctl delbr brl4l7; } > /dev/null 2>&1
brctl addbr brl4l7;ip l s brl4l7 up

{ ip l s brl7 down && brctl delbr brl7; } > /dev/null 2>&1
brctl addbr brl7;ip l s brl7 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: l4l7lb
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    brl4:
      kind: bridge

    keepalived1-haproxy1:
      kind: linux
      image: 192.168.2.100:5000/keepalived-2.0.8-haproxy-1.5.18
      exec:
      - ip a a 10.1.5.99/24 dev net1
      - keepalived -D  -f /etc/keepalived/keepalived.conf
      - haproxy -f /etc/haproxy/haproxy.cfg
      cmd: sleep infinity 
      binds:
        - ./keepalived/keepalived1/keepalived.conf:/etc/keepalived/keepalived.conf
        - ./haproxy/haproxy1/haproxy.cfg:/etc/haproxy/haproxy.cfg

    keepalived2-haproxy2:
      kind: linux
      image: 192.168.2.100:5000/keepalived-2.0.8-haproxy-1.5.18
      cmd: sleep infinity
      exec:
      - ip a a 10.1.5.101/24 dev net1
      - keepalived -D  -f /etc/keepalived/keepalived.conf
      - haproxy -f /etc/haproxy/haproxy.cfg
      binds:
        - ./keepalived/keepalived2/keepalived.conf:/etc/keepalived/keepalived.conf
        - ./haproxy/haproxy2/haproxy.cfg:/etc/haproxy/haproxy.cfg

    nginx1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.80/24 dev net0
      - ip route replace default via 10.1.5.1

    nginx2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.90/24 dev net0
      - ip route replace default via 10.1.5.1

    client:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.5/24 dev net0
      - ip route replace default via 10.1.5.1


  links:
    - endpoints: ["nginx1:net0", "brl4:net1"]
    - endpoints: ["nginx2:net0", "brl4:net2"]
    - endpoints: ["keepalived1-haproxy1:net1", "brl4:net3"]
    - endpoints: ["keepalived2-haproxy2:net1", "brl4:net4"]
    - endpoints: ["client:net0", "brl4:net5"]
EOF

