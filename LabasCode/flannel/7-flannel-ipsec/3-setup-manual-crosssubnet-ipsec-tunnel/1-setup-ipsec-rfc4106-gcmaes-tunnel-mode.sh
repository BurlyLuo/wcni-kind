#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ipsec-tunnel-mode-aes-gcm
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2
      - ip a a 10.1.9.1/24 dev net3

    ipsec1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.1.1/24 dev eth1
      - ip addr add 10.1.5.10/24 dev eth2
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev eth2
      - ip r a 10.1.9.0/24 via 10.1.5.1 dev eth2

      # https://datatracker.ietf.org/doc/html/rfc4106
      # 0xfa42aa6bc685beb4d967057134dd8e327ca17977 [fa42aa6bc685beb4d967057134dd8e32 7ca17977]
      # fa42aa6bc685beb4d967057134dd8e32 >>>[key length: 32*4=128]
      # 7ca17977 >>>[salt length: 8*4=32]
      # 128 >>>[128 mean ICV Length. The ICV consists solely of the AES-GCM Authentication Tag. Implementations MUST support a full-length 16-octet ICV, and MAY support 8 or 12 octet ICVs, and MUST NOT support other ICV lengths. Although ESP does not require that an ICV be present, AES-GCM-ESP intentionally does not allow a zero-length ICV. This is because GCM provides no integrity protection whatsoever when used with a zero-length Authentication Tag. <> {16-octet=16*8=128||8-octet=8*8=64||12-octet=12*8=96}]
      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128
      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128

      - ip xfrm state add src 10.1.5.10 dst 10.1.9.10 proto esp spi 0xfe51d978 reqid 0xfe51d978 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17978 128
      - ip xfrm state add src 10.1.9.10 dst 10.1.5.10 proto esp spi 0xfe51d978 reqid 0xfe51d978 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17978 128

      - ip xfrm policy add src 10.244.1.10/24 dst 10.244.2.10/24 dir out tmpl src 10.1.5.10 dst 10.1.8.10 proto esp reqid 0xfe51d977 mode tunnel
      - ip xfrm policy add src 10.244.2.10/24 dst 10.244.1.10/24 dir fwd tmpl src 10.1.8.10 dst 10.1.5.10 proto esp reqid 0xfe51d977 mode tunnel
      - ip xfrm policy add src 10.244.2.10/24 dst 10.244.1.10/24 dir in  tmpl src 10.1.8.10 dst 10.1.5.10 proto esp reqid 0xfe51d977 mode tunnel

      - ip xfrm policy add src 10.244.1.10/24 dst 10.244.3.10/24 dir out tmpl src 10.1.5.10 dst 10.1.9.10 proto esp reqid 0xfe51d978 mode tunnel
      - ip xfrm policy add src 10.244.3.10/24 dst 10.244.1.10/24 dir fwd tmpl src 10.1.9.10 dst 10.1.5.10 proto esp reqid 0xfe51d978 mode tunnel
      - ip xfrm policy add src 10.244.3.10/24 dst 10.244.1.10/24 dir in  tmpl src 10.1.9.10 dst 10.1.5.10 proto esp reqid 0xfe51d978 mode tunnel
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE
     
      binds:
        - ./ipsecdump.sh:/ipsecdump.sh


    ipsec2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.2.1/24 dev eth1
      - ip addr add 10.1.8.10/24 dev eth2
      - ip r a 10.1.5.0/24 via 10.1.8.1 dev eth2
      - ip r a 10.1.9.0/24 via 10.1.8.1 dev eth2

      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128
      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128

      - ip xfrm state add src 10.1.8.10 dst 10.1.9.10 proto esp spi 0xfe51d979 reqid 0xfe51d979 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17979 128
      - ip xfrm state add src 10.1.9.10 dst 10.1.8.10 proto esp spi 0xfe51d979 reqid 0xfe51d979 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17979 128

      - ip xfrm policy add src 10.244.2.10/24 dst 10.244.1.10/24 dir out tmpl src 10.1.8.10 dst 10.1.5.10 proto esp reqid 0xfe51d977 mode tunnel
      - ip xfrm policy add src 10.244.1.10/24 dst 10.244.2.10/24 dir fwd tmpl src 10.1.5.10 dst 10.1.8.10 proto esp reqid 0xfe51d977 mode tunnel
      - ip xfrm policy add src 10.244.1.10/24 dst 10.244.2.10/24 dir in  tmpl src 10.1.5.10 dst 10.1.8.10 proto esp reqid 0xfe51d977 mode tunnel

      - ip xfrm policy add src 10.244.2.10/24 dst 10.244.3.10/24 dir out tmpl src 10.1.8.10 dst 10.1.9.10 proto esp reqid 0xfe51d979 mode tunnel
      - ip xfrm policy add src 10.244.3.10/24 dst 10.244.2.10/24 dir fwd tmpl src 10.1.9.10 dst 10.1.8.10 proto esp reqid 0xfe51d979 mode tunnel
      - ip xfrm policy add src 10.244.3.10/24 dst 10.244.2.10/24 dir in  tmpl src 10.1.9.10 dst 10.1.8.10 proto esp reqid 0xfe51d979 mode tunnel
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

      binds:
        - ./ipsecdump.sh:/ipsecdump.sh


    ipsec3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.244.3.1/24 dev eth1
      - ip addr add 10.1.9.10/24 dev eth2
      - ip r a 10.1.5.0/24 via 10.1.9.1 dev eth2
      - ip r a 10.1.8.0/24 via 10.1.9.1 dev eth2

      - ip xfrm state add src 10.1.9.10 dst 10.1.5.10 proto esp spi 0xfe51d978 reqid 0xfe51d978 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17978 128
      - ip xfrm state add src 10.1.5.10 dst 10.1.9.10 proto esp spi 0xfe51d978 reqid 0xfe51d978 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17978 128

      - ip xfrm state add src 10.1.9.10 dst 10.1.8.10 proto esp spi 0xfe51d979 reqid 0xfe51d979 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17979 128
      - ip xfrm state add src 10.1.8.10 dst 10.1.9.10 proto esp spi 0xfe51d979 reqid 0xfe51d979 mode tunnel aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17979 128

      - ip xfrm policy add src 10.244.3.10/24 dst 10.244.1.10/24 dir out tmpl src 10.1.9.10 dst 10.1.5.10 proto esp reqid 0xfe51d978 mode tunnel
      - ip xfrm policy add src 10.244.1.10/24 dst 10.244.3.10/24 dir fwd tmpl src 10.1.5.10 dst 10.1.9.10 proto esp reqid 0xfe51d978 mode tunnel
      - ip xfrm policy add src 10.244.1.10/24 dst 10.244.3.10/24 dir in  tmpl src 10.1.5.10 dst 10.1.9.10 proto esp reqid 0xfe51d978 mode tunnel

      - ip xfrm policy add src 10.244.3.10/24 dst 10.244.2.10/24 dir out tmpl src 10.1.9.10 dst 10.1.8.10 proto esp reqid 0xfe51d979 mode tunnel
      - ip xfrm policy add src 10.244.2.10/24 dst 10.244.3.10/24 dir fwd tmpl src 10.1.8.10 dst 10.1.9.10 proto esp reqid 0xfe51d979 mode tunnel
      - ip xfrm policy add src 10.244.2.10/24 dst 10.244.3.10/24 dir in  tmpl src 10.1.8.10 dst 10.1.9.10 proto esp reqid 0xfe51d979 mode tunnel
      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

      binds:
        - ./ipsecdump.sh:/ipsecdump.sh


    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.244.1.10/24 dev net0
      - ip route replace default via 10.244.1.1
      - bash -c "/root/udp_server &"
      binds:
        - ./udp/udp_client:/root/udp_client
        - ./udp/udp_server:/root/udp_server

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.244.2.10/24 dev net0
      - ip route replace default via 10.244.2.1
      - bash -c "/root/udp_server &"
      binds:
        - ./udp/udp_client:/root/udp_client
        - ./udp/udp_server:/root/udp_server

    server3:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.244.3.10/24 dev net0
      - ip route replace default via 10.244.3.1
      - bash -c "/root/udp_server &"
      binds:
        - ./udp/udp_client:/root/udp_client
        - ./udp/udp_server:/root/udp_server

  links:
    - endpoints: ["ipsec1:eth1", "server1:net0"]
      mtu: 1500
    - endpoints: ["ipsec2:eth1", "server2:net0"]
      mtu: 1500
    - endpoints: ["ipsec3:eth1", "server3:net0"]
      mtu: 1500
    - endpoints: ["ipsec1:eth2", "gwx:net1"]
      mtu: 1500
    - endpoints: ["ipsec2:eth2", "gwx:net2"]
      mtu: 1500
    - endpoints: ["ipsec3:eth2", "gwx:net3"]
      mtu: 1500
EOF
