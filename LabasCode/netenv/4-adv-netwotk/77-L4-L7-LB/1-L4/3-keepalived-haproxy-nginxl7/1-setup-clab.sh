#!/bin/bash
set -v

# topo:    
#        keepalived1+haproxy1           nginx1
#          ---10.1.5.99/24-------------10.1.5.80---web1(nginx)
#          |                         /
# client---| keepalived+haproxy 10.1.5.100/24  
#          |                         \
#          ---10.1.5.98/24-------------10.1.5.90---web2(nginx)
#        keepalived2+jhaproxy2          nginx2

{ ip l s brl4l7 down && brctl delbr brl4l7; } > /dev/null 2>&1
brctl addbr brl4l7;ip l s brl4l7 up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: l4l7lb
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    brl4l7:
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
      image: 192.168.2.100:5000/nginx:1.7.9
      exec:
      - ip addr add 10.1.5.80/24 dev net0
      - ip route replace default via 10.1.5.1
      binds:
        - ./nginx/nginx1/default.conf:/etc/nginx/conf.d/default.conf

    nginx2:
      kind: linux
      image: 192.168.2.100:5000/nginx:1.7.9
      exec:
      - ip addr add 10.1.5.90/24 dev net0
      - ip route replace default via 10.1.5.1
      binds:
        - ./nginx/nginx2/default.conf:/etc/nginx/conf.d/default.conf

    web1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.200/24 dev net0
      - ip route replace default via 10.1.5.1

    web2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.201/24 dev net0
      - ip route replace default via 10.1.5.1
      
    client:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.5/24 dev net0
      - ip route replace default via 10.1.5.1
      - sh -c 'echo "10.1.5.100 www.wluo.com" >> /etc/hosts'

  links:
    - endpoints: ["nginx1:net0", "brl4l7:net1"]
    - endpoints: ["nginx2:net0", "brl4l7:net2"]
    - endpoints: ["keepalived1-haproxy1:net1", "brl4l7:net3"]
    - endpoints: ["keepalived2-haproxy2:net1", "brl4l7:net4"]
    - endpoints: ["client:net0", "brl4l7:net5"]
    - endpoints: ["web1:net0", "brl4l7:net6"]
    - endpoints: ["web2:net0", "brl4l7:net7"]
EOF

