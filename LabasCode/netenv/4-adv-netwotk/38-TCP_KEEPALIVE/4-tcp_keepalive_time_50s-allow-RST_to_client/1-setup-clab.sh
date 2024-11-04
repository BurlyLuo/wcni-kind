#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp_keepalive_time_50s_allow_rst
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni_http_keepalive_timeout_500s
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - iptables -A FORWARD -s 10.1.8.10/32 -d 10.1.5.10/32 -p tcp -m tcp --tcp-flags SYN,ACK SYN,ACK -j ACCEPT
      - iptables -A FORWARD -s 10.1.8.10 -d 10.1.5.10 -p tcp --tcp-flags ACK ACK -j DROP

      env:
        TZ: Asia/Shanghai

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni_http_keepalive_timeout_500s
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev net0
      - >
        bash -c '
        bash -c "sysctl net.ipv4.tcp_keepalive_time=50" && bash -c "sysctl net.ipv4.tcp_keepalive_probes=2" && bash -c "sysctl net.ipv4.tcp_keepalive_intvl=6"'
      binds:
        - ./client:/client

      env:
        TZ: Asia/Shanghai

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni_http_keepalive_timeout_500s
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r a 10.1.5.0/24 via 10.1.8.1 dev net0
      - >
        bash -c '
        bash -c "sysctl net.ipv4.tcp_keepalive_time=50" && bash -c "sysctl net.ipv4.tcp_keepalive_probes=2" && bash -c "sysctl net.ipv4.tcp_keepalive_intvl=6"'
      binds:
        - ./server:/server

      env:
        TZ: Asia/Shanghai


  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw1:eth2", "server2:net0"]

EOF

