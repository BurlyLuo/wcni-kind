#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-fin-wait1
topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - iptables -A FORWARD -s 10.1.5.10 -d 10.1.8.10 -p tcp --tcp-flags FIN,ACK FIN,ACK -j DROP

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
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw1:eth2", "server2:net0"]
EOF

# 1.cmd:
# iptables -A FORWARD -s 10.1.5.10 -d 10.1.8.10 -p tcp --tcp-flags FIN,ACK FIN,ACK -j DROP

# 2.test
# [root@client /]# curl 10.1.8.10 
# ...  waiting...

# 3. monitor netstat outputs[client]
# [root@server1 /]# while true;do netstat -anp | grep 10.1.5.10;done
# tcp        0      1 10.1.5.10:34038         10.1.8.10:80            FIN_WAIT1   -                   
# tcp        0      1 10.1.5.10:34038         10.1.8.10:80            FIN_WAIT1   -                   
# tcp        0      1 10.1.5.10:34038         10.1.8.10:80            FIN_WAIT1   -                   
# tcp        0      1 10.1.5.10:34038         10.1.8.10:80            FIN_WAIT1   -                   
# tcp        0      1 10.1.5.10:34038         10.1.8.10:80            FIN_WAIT1   -                   
# tcp        0      1 10.1.5.10:34038         10.1.8.10:80            FIN_WAIT1   -

# 4. monitor netstat outputs[server]
# tcp        0      0 10.1.8.10:80            10.1.5.10:37558         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:37558         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:37558         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:37558         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:37558         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:37558         ESTABLISHED 15/nginx: worker pr 
# tcp        0      0 10.1.8.10:80            10.1.5.10:37558         ESTABLISHED 15/nginx: worker pr 
