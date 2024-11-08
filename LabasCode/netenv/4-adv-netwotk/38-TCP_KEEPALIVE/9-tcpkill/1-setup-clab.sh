#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcpkill
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
      - bash -c "/server &"
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

# yum -y install dsniff
# tcpkill -h

# [root@server2 ~]# tcpkill -i net0 host 10.1.8.10 and host 10.1.5.10
#tcpkill: listening on net0 [host 10.1.8.10 and host 10.1.5.10]
#10.1.8.10:6699 > 10.1.5.10:43362: R 3760692414:3760692414(0) win 0
#10.1.8.10:6699 > 10.1.5.10:43362: R 3760692857:3760692857(0) win 0
#10.1.8.10:6699 > 10.1.5.10:43362: R 3760693743:3760693743(0) win 0
#10.1.5.10:43362 > 10.1.8.10:6699: R 996822496:996822496(0) win 0
#10.1.5.10:43362 > 10.1.8.10:6699: R 996822940:996822940(0) win 0
#10.1.5.10:43362 > 10.1.8.10:6699: R 996823828:996823828(0) win 0
#[root@rowan> 3-tcp_keepalive_time_50s]# 

#[root@server2 /]# netstat  -anp | grep 6699
#tcp        0      0 0.0.0.0:6699            0.0.0.0:*               LISTEN      55/./server         
#tcp        0      0 10.1.8.10:6699          10.1.5.10:43362         ESTABLISHED 55/./server         
#[root@server2 /]# netstat  -anp | grep 6699
#tcp        0      0 0.0.0.0:6699            0.0.0.0:*               LISTEN      55/./server         
#tcp        0      0 10.1.8.10:6699          10.1.5.10:43362         ESTABLISHED 55/./server         
#[root@server2 /]# netstat  -anp | grep 6699
#tcp        0      0 0.0.0.0:6699            0.0.0.0:*               LISTEN      55/./server       

