#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: http_keepalive_timeout_65s
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni_http_keepalive_timeout_65s
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      #- iptables -A FORWARD -s 10.1.5.10 -d 10.1.8.10 -p tcp --tcp-flags FIN,ACK FIN,ACK -j DROP
      - iptables -A FORWARD -p tcp --tcp-flags FIN,ACK FIN,ACK -j DROP
      env:
        TZ: Asia/Shanghai

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni_http_keepalive_timeout_65s
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev net0
      env:
        TZ: Asia/Shanghai


    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni_http_keepalive_timeout_65s
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r a 10.1.5.0/24 via 10.1.8.1 dev net0
      env:
        TZ: Asia/Shanghai


  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw1:eth2", "server2:net0"]

EOF
