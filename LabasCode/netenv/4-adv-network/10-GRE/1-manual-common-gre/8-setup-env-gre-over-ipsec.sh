#!/bin/bash
set -v 
cat <<EOF
How Do I Configure GRE over IPSec or IPSec over GRE?
IPSec tunnels only support encapsulation and encryption of unicast packets, whereas GRE tunnels support encapsulation and encryption of both unicast and multicast packets. However, GRE tunnels are insecure. Huawei AR series routers leverage the advantages of IPSec and GRE and communicate with each other using IPSec over GRE or GRE over IPSec. GRE over IPSec is supported by all AR models and versions, whereas IPSec over GRE is supported only by AR models that run V200R005C10 or later versions.

IPSec over GRE

IPSec over GRE technology uses GRE to encapsulate packets that have been encapsulated using IPSec. IPSec over GRE implements IPSec encryption on tunnel interfaces. The system detects data flows that need to be encrypted on tunnel interfaces (an ACL is configured to match data flows between two user network segments). Any packets that match the ACL are encapsulated into IPSec packets and then into GRE packets before they are transmitted over the tunnel Packets that do not match the ACL are directly transmitted over the GRE tunnel without being encapsulated using IPSec, which means these packets are not transmitted in a secure manner In addition, a GRE tunnel is not protected by IPSec while it is set up.

For the configuration procedure, see:

CLI-based Configuration > VPN Configuration Guide > Example for Establishing GRE over IPSec Tunnel Using a Tunnel Interface in the product documentation
CLI-based Typical Configuration Examples > Using VPN to Implement WAN Interconnection > Example for Configuring IPsec over GRE to Implement Secure Communication Between the Headquarters and Branches in the product documentation
GRE over IPSec

GRE over IPSec technology uses IPSec to encapsulate packets that have been encapsulated by GRE. GRE over IPSec implements IPSec encryption on physical interfaces. The system detects GRE data flows that need to be encrypted on physical interfaces (an ACL is configured to match GRE data flows between two gateways). In this way, all data flows that are transmitted over the GRE tunnel are protected by IPSec. The GRE tunnel is also protected by IPSec while it is set up.

GRE over IPSec supports encapsulation in both tunnel and transport modes. The tunnel mode uses an extra IPSec header, which increases the packet size and makes packets more likely to be fragmented. Therefore, the transport mode is recommended. For the detailed configuration, see:
CLI-based Typical Configuration Examples > Using VPN to Implement WAN Interconnection > Example for Configuring GRE Over IPSec to Implement Communication Between Devices in the product documentation
CLI-based Typical Configuration Examples > Using VPN to Implement WAN Interconnection > Example for Configuring OSPF and GRE Over IPSec to Implement Communication Between the Branch and Headquarters in the product documentation
CLI-based Typical Configuration Examples > Using VPN to Implement WAN Interconnection > Example for Configuring GRE Over IPSec to Implement Communication Between the Branches and Headquarters and NAT to Implement Communication Between Branches (Running OSPF) in the product documentation
EOF


cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: gre-ipv6-ipv4-ipsec
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2

    gre1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:1::1/64 dev eth1
      - ip addr add 10.1.5.10/24 dev eth2
      # P-to-P GRE Tunnel:
      - ip l a gre00 type gre local 10.1.5.10 remote 10.1.8.10
      - ip l s gre00 up
      - ip a a 1:1:1::1/64 dev gre00
     
      - ip r a 10:244:2::/64 via 1:1:1::2 dev gre00 onlink

      - ip route replace default via 10.1.5.1 dev eth2 

      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"


      # ipsec
      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4106(gcm(aes))' 0x1234566bc685beb4d967057134dd8e327ca17977 128
      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d978 reqid 0xfe51d978 mode transport aead 'rfc4106(gcm(aes))' 0x6543216bc685beb4d967057134dd8e327ca17978 128

      - ip xfrm policy add src 10.1.5.10/24 dst 10.1.8.10/24 dir out tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d977 mode transport
      - ip xfrm policy add src 10.1.8.10/24 dst 10.1.5.10/24 dir in  tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d978 mode transport

      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    gre2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10:244:2::1/64 dev eth1
      - ip addr add 10.1.8.10/24 dev eth2

      - ip l a gre00 type gre local 10.1.8.10 remote 10.1.5.10
      - ip l s gre00 up
      - ip a a 1:1:1::2/64 dev gre00

      - ip r a 10:244:1::/64 via 1:1:1::1 dev gre00 onlink

      - ip route replace default via 10.1.8.1 dev eth2
      
      - bash -c "sysctl -w net.ipv6.conf.all.forwarding=1"

      - ip xfrm state add src 10.1.8.10 dst 10.1.5.10 proto esp spi 0xfe51d978 reqid 0xfe51d978 mode transport aead 'rfc4106(gcm(aes))' 0x6543216bc685beb4d967057134dd8e327ca17978 128
      - ip xfrm state add src 10.1.5.10 dst 10.1.8.10 proto esp spi 0xfe51d977 reqid 0xfe51d977 mode transport aead 'rfc4106(gcm(aes))' 0x1234566bc685beb4d967057134dd8e327ca17977 128

      - ip xfrm policy add src 10.1.8.10/24 dst 10.1.5.10/24 dir out tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d978 mode transport
      - ip xfrm policy add src 10.1.5.10/24 dst 10.1.8.10/24 dir in  tmpl src 0.0.0.0 dst 0.0.0.0 proto esp reqid 0xfe51d977 mode transport

      - iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o eth0 -j MASQUERADE

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10:244:1::10/64 dev net0
      - ip route replace default via 10:244:1::1
      # - curl [10:244:2::10]

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10:244:2::10/64 dev net0
      - ip route replace default via 10:244:2::1

  links:
    - endpoints: ["gre1:eth1", "server1:net0"]
      mtu: 1500
    - endpoints: ["gre2:eth1", "server2:net0"]
      mtu: 1500

    - endpoints: ["gre1:eth2", "gwx:net1"]
      mtu: 1500
    - endpoints: ["gre2:eth2", "gwx:net2"]
      mtu: 1500
EOF
