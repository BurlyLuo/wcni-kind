#!/bin/bash
set -v
# https://www.rfc-editor.org/rfc/rfc4106.txt
cat <<EOF
8.0.  Key Length Attribute

   Because the AES supports three key lengths, the Key Length attribute
   MUST be specified in the IKE Phase 2 exchange [RFC2407].  The Key
   Length attribute MUST have a value of 128, 192, or 256.

8.1.  Keying Material and Salt Values

   IKE makes use of a pseudo-random function (PRF) to derive keying
   material.  The PRF is used iteratively to derive keying material of
   arbitrary size, called KEYMAT.  Keying material is extracted from the
   output string without regard to boundaries.

   The size of the KEYMAT for the AES-GCM-ESP MUST be four octets longer
   than is needed for the associated AES key.  The keying material is
   used as follows:

   AES-GCM-ESP with a 128 bit key
      The KEYMAT requested for each AES-GCM key is 20 octets.  The first
      16 octets are the 128-bit AES key, and the remaining four octets
      are used as the salt value in the nonce.

   AES-GCM-ESP with a 192 bit key
      The KEYMAT requested for each AES-GCM key is 28 octets.  The first
      24 octets are the 192-bit AES key, and the remaining four octets
      are used as the salt value in the nonce.

   AES-GCM-ESP with a 256 bit key
      The KEYMAT requested for each AES GCM key is 36 octets.  The first
      32 octets are the 256-bit AES key, and the remaining four octets
      are used as the salt value in the nonce.

8.3.  Phase 2 Identifier

   For IKE Phase 2 negotiations, IANA has assigned three ESP Transform
   Identifiers for AES-GCM with an eight-byte explicit IV:

      18 for AES-GCM with an 8 octet ICV;
      19 for AES-GCM with a 12 octet ICV; and
      20 for AES-GCM with a 16 octet ICV.

EOF

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

    ipsec1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth2
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev eth2
      - ip r a 10.1.9.0/24 via 10.1.5.1 dev eth2

      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128
      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128

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
      - ip r a 10.1.9.0/24 via 10.1.8.1 dev eth2

      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128
      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4106(gcm(aes))' 0xfa42aa6bc685beb4d967057134dd8e327ca17977 128
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
