#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-last-ack
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - iptables -A FORWARD -s 10.1.8.10 -d 10.1.5.10 -p tcp --tcp-flags FIN,ACK FIN,ACK -j DROP

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r r default via 10.1.5.1 dev net0

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r r default via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw1:eth2", "server2:net0"]

EOF

# 1.cmd:
# iptables -A FORWARD -s 10.1.8.10 -d 10.1.5.10 -p tcp --tcp-flags FIN,ACK FIN,ACK -j DROP

# 2.test
# [root@server1 /]# curl 10.1.8.10 
# ...  waiting...

# 3. monitor netstat outputs[server1]
# [root@server1 /]# while true;do netstat -anp | grep 10.1.5.10;done
# tcp        0      0 10.1.5.10:57304         10.1.8.10:80            FIN_WAIT2   - 
# tcp        0      0 10.1.5.10:57304         10.1.8.10:80            FIN_WAIT2   - 
# tcp        0      0 10.1.5.10:57304         10.1.8.10:80            FIN_WAIT2   - 
# tcp        0      0 10.1.5.10:57304         10.1.8.10:80            FIN_WAIT2   - 
# tcp        0      0 10.1.5.10:57304         10.1.8.10:80            FIN_WAIT2   - 
# 4. monitor netstat outputs[server2]
# tcp        0      1 10.1.8.10:80            10.1.5.10:57304         LAST_ACK    -
# tcp        0      1 10.1.8.10:80            10.1.5.10:57304         LAST_ACK    -
# tcp        0      1 10.1.8.10:80            10.1.5.10:57304         LAST_ACK    -
# tcp        0      1 10.1.8.10:80            10.1.5.10:57304         LAST_ACK    -
# tcp        0      1 10.1.8.10:80            10.1.5.10:57304         LAST_ACK    -
