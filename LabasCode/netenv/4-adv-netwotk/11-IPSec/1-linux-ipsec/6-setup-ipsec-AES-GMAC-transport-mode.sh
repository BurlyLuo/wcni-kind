#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ipsec-transport-mode-gmac
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2

    ipsec1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth2
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev eth2

      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4543(gcm(aes))' 0x40d3a54c5ae9ee8f23f73729975a3db58eb5cdbb 128
      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4543(gcm(aes))' 0x40d3a54c5ae9ee8f23f73729975a3db58eb5cdbb 128

      - ip xfrm policy add src 10.1.5.10/24 dst 10.1.8.10/24 proto tcp sport 81 dport 80 dir out tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d977 mode transport
      - ip xfrm policy add src 10.1.8.10/24 dst 10.1.5.10/24 proto tcp sport 81 dport 80 dir in  tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d977 mode transport

      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE
      
      #- ipsecdump -i eth2 -m transport -t 5000s

      binds:
        - ./ipsecdump.sh:/ipsecdump.sh

    ipsec2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev eth2
      - ip r a 10.1.5.0/24 via 10.1.8.1 dev eth2

      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4543(gcm(aes))' 0x40d3a54c5ae9ee8f23f73729975a3db58eb5cdbb 128
      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4543(gcm(aes))' 0x40d3a54c5ae9ee8f23f73729975a3db58eb5cdbb 128
      - ip xfrm policy add src 10.1.8.10/24 dst 10.1.5.10/24 proto tcp sport 80 dport 81 dir out tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d977 mode transport
      - ip xfrm policy add src 10.1.5.10/24 dst 10.1.8.10/24 proto tcp sport 80 dport 81 dir in  tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d977 mode transport

      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

      #- ipsecdump -i eth2 -m transport -t 5000s

      binds:
        - ./ipsecdump.sh:/ipsecdump.sh


  links:
    - endpoints: ["ipsec1:eth2", "gwx:net1"]
    - endpoints: ["ipsec2:eth2", "gwx:net2"]
    
EOF
