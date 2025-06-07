#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: lab
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    openssl_client:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1
      binds:
        - ./client.crt:/root/client.crt
        - ./client.key:/root/client.key
        - ./CA_Server.crt:/root/CA_Server.crt

      # 2. test step:
      # openssl s_client -connect 10.1.8.10:50008 -cert client.crt -key client.key -CAfile CA_Server.crt -tls1_2


    openssl_server:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1
      
      # 1. setup openssl server
      # openssl s_server -cert server.crt -key server.key -port 50008 -CAfile CA_Client.crt -Verify 1

      binds:
        - ./server.crt:/root/server.crt
        - ./server.key:/root/server.key
        - ./CA_Client.crt:/root/CA_Client.crt

  links:
    - endpoints: ["gwx:eth1", "openssl_client:net0"]
      mtu: 1500
    - endpoints: ["gwx:eth2", "openssl_server:net0"]
      mtu: 1500
EOF

# 1. setup openssl server
docker exec -it -d clab-lab-openssl_server openssl s_server -cert server.crt -key server.key -port 50008 -CAfile CA_Client.crt -Verify 1

# 2. test step:
echo "openssl s_client -connect 10.1.8.10:50008 -cert client.crt -key client.key -CAfile CA_Server.crt -tls1_2"
docker exec -it clab-lab-openssl_client bash
