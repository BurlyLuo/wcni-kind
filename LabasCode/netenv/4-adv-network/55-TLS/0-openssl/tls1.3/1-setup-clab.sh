#!/bin/bash
set -v

openssl ecparam -name prime256v1 -genkey -noout -out ecdsa.key
openssl req -new -x509 -key ecdsa.key -out ecdsa.crt -days 36500 -subj "/CN=wei.luo"

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: lab
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev eth1
      - ip a a 10.1.8.1/24 dev eth2
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    openssl_client:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip route replace default via 10.1.5.1
      binds:
        - ./ecdsa.crt:/root/ecdsa.crt

      # 2. test step:
      # openssl s_client -connect 10.1.8.10:50008 -tls1_3 -ciphersuites TLS_AES_256_GCM_SHA384 -CAfile /root/ecdsa.crt


    openssl_server:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip route replace default via 10.1.8.1
      
      # 1. setup openssl server
      # openssl s_server -cert /root/ecdsa.crt -key /root/ecdsa.key -port 50008 -tls1_3 -ciphersuites TLS_AES_256_GCM_SHA384

      binds:
        - ./ecdsa.key:/root/ecdsa.key
        - ./ecdsa.crt:/root/ecdsa.crt

  links:
    - endpoints: ["gwx:eth1", "openssl_client:net0"]
      mtu: 1500
    - endpoints: ["gwx:eth2", "openssl_server:net0"]
      mtu: 1500
EOF

# 1. setup openssl server
docker exec -it -d clab-lab-openssl_server openssl s_server -cert /root/ecdsa.crt -key /root/ecdsa.key -port 50008 -tls1_3 -ciphersuites TLS_AES_256_GCM_SHA384

# 2. test step:
echo "openssl s_client -connect 10.1.8.10:50008 -tls1_3 -ciphersuites TLS_AES_256_GCM_SHA384 -CAfile /root/ecdsa.crt"
docker exec -it clab-lab-openssl_client bash
