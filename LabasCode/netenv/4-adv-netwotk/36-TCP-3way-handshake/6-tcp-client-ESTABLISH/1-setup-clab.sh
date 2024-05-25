#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-client-establish
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
      - iptables -A FORWARD -s 10.1.5.10 -d 10.1.8.10 -p tcp --tcp-flags ACK ACK -j DROP

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
# iptables -A FORWARD -s 10.1.5.10 -d 10.1.8.10 -p tcp --tcp-flags ACK ACK -j DROP

# 2.test
# [root@server1 /]# curl 10.1.8.10 
# ...  waiting...

# 3. monitor netstat outputs[server1]
# tcp        0     73 10.1.5.10:60142         10.1.8.10:80            ESTABLISHED 17400/curl          
# tcp        0     73 10.1.5.10:60142         10.1.8.10:80            ESTABLISHED 17400/curl          
# tcp        0     73 10.1.5.10:60142         10.1.8.10:80            ESTABLISHED 17400/curl          
# tcp        0     73 10.1.5.10:60142         10.1.8.10:80            ESTABLISHED 17400/curl          
# tcp        0     73 10.1.5.10:60142         10.1.8.10:80            ESTABLISHED 17400/curl          
# tcp        0     73 10.1.5.10:60142         10.1.8.10:80            ESTABLISHED 17400/curl          

# 3.1 monitor netstat outputs[server2]{not come into ESTABLISH status}
# tcp        0      0 10.1.8.10:80            10.1.5.10:53248         SYN_RECV    -                   
# tcp        0      0 10.1.8.10:80            10.1.5.10:53248         SYN_RECV    -                   
# tcp        0      0 10.1.8.10:80            10.1.5.10:53248         SYN_RECV    -                   
# tcp        0      0 10.1.8.10:80            10.1.5.10:53248         SYN_RECV    -                   
# tcp        0      0 10.1.8.10:80            10.1.5.10:53248         SYN_RECV    -                   
# tcp        0      0 10.1.8.10:80            10.1.5.10:53248         SYN_RECV    -  

