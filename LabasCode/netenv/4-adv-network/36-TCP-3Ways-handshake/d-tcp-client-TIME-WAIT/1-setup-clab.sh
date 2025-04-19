#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-client-time-wait
topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/xcni-http-keepalive-500s
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2

    client:
      kind: linux
      image: 192.168.2.100:5000/xcni-http-keepalive-500s
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r r default via 10.1.5.1 dev net0

    server:
      kind: linux
      image: 192.168.2.100:5000/xcni-http-keepalive-500s
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r r default via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "client:net0"]
    - endpoints: ["gw1:eth2", "server:net0"]
EOF

# 1.cmd:
# n/a
 
# 2.test
# [root@client /]# curl 10.1.8.10 
# ...  waiting...

# 3. monitor netstat outputs[server1]
# [root@client ~]# curl --local-port 12345 10.1.8.10 && while true;do sum=$(netstat -anp | grep TIME_WAIT | wc -l);if [ $sum -eq 1 ]; then date;else break;fi;sleep 2;done
# PodName: server | PodIP: eth0 172.20.20.2/24
# Wed Nov 22 13:53:21 UTC 2023
# Wed Nov 22 13:53:23 UTC 2023
# Wed Nov 22 13:53:25 UTC 2023
# Wed Nov 22 13:53:27 UTC 2023
# Wed Nov 22 13:53:29 UTC 2023
# Wed Nov 22 13:53:31 UTC 2023
# Wed Nov 22 13:53:33 UTC 2023
# Wed Nov 22 13:53:35 UTC 2023
# Wed Nov 22 13:53:37 UTC 2023
# Wed Nov 22 13:53:39 UTC 2023
# Wed Nov 22 13:53:41 UTC 2023
# Wed Nov 22 13:53:43 UTC 2023
# Wed Nov 22 13:53:45 UTC 2023
# Wed Nov 22 13:53:47 UTC 2023
# Wed Nov 22 13:53:49 UTC 2023
# Wed Nov 22 13:53:51 UTC 2023
# Wed Nov 22 13:53:53 UTC 2023
# Wed Nov 22 13:53:55 UTC 2023
# Wed Nov 22 13:53:57 UTC 2023
# Wed Nov 22 13:53:59 UTC 2023
# Wed Nov 22 13:54:01 UTC 2023
# Wed Nov 22 13:54:03 UTC 2023
# Wed Nov 22 13:54:05 UTC 2023
# Wed Nov 22 13:54:07 UTC 2023
# Wed Nov 22 13:54:09 UTC 2023
# Wed Nov 22 13:54:11 UTC 2023
# Wed Nov 22 13:54:13 UTC 2023
# Wed Nov 22 13:54:15 UTC 2023
# Wed Nov 22 13:54:17 UTC 2023
# Wed Nov 22 13:54:19 UTC 2023
