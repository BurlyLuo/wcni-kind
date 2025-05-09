#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-server-establish
topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - iptables -A FORWARD -s 10.1.5.10 -d 10.1.8.10 -p tcp --tcp-flags PSH,ACK PSH,ACK -j DROP

    client:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r r default via 10.1.5.1 dev net0

    server:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r r default via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "client:net0"]
    - endpoints: ["gw1:eth2", "server:net0"]
EOF

# 1.cmd:
# iptables -A FORWARD -s 10.1.5.10 -d 10.1.8.10 -p tcp --tcp-flags PSH,ACK PSH,ACK -j DROP

# 2.test
# [root@client /]# curl 10.1.8.10 
# ...  waiting...

# 3. monitor netstat outputs[client]{keep into ESTABLISH status}
[root@server1 /]# while true;do netstat -anp | grep EST;done
# tcp        0     73 10.1.5.10:50396         10.1.8.10:80            ESTABLISHED 28865/curl          
# tcp        0     73 10.1.5.10:50396         10.1.8.10:80            ESTABLISHED 28865/curl          
# tcp        0     73 10.1.5.10:50396         10.1.8.10:80            ESTABLISHED 28865/curl          
# tcp        0     73 10.1.5.10:50396         10.1.8.10:80            ESTABLISHED 28865/curl          
# tcp        0     73 10.1.5.10:50396         10.1.8.10:80            ESTABLISHED 28865/curl          
# tcp        0     73 10.1.5.10:50396         10.1.8.10:80            ESTABLISHED 28865/curl  

# 3.1 monitor netstat outputs[server]{keep into ESTABLISH status}
# [root@server2 /]# while true;do netstat -anp | grep ESTA;done         
# tcp        0      0 10.1.8.10:80            10.1.5.10:50396         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:50396         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:50396         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:50396         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:50396         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:50396         ESTABLISHED 15/nginx: worker pr 
