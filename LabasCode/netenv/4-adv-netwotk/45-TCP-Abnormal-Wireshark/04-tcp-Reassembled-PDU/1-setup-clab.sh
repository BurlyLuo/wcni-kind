#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp-reassembled-pdu
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:
    gw1:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw1-boot.cfg:/opt/vyatta/etc/config/config.boot

    gw2:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/gw2-boot.cfg:/opt/vyatta/etc/config/config.boot

    server1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0
      - ip r a 10.1.8.0/24 via 10.1.5.1 dev net0

    server2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.8.10/24 dev net0
      - ip r a 10.1.5.0/24 via 10.1.8.1 dev net0

  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw2:eth1", "server2:net0"]
    - endpoints: ["gw1:eth2", "gw2:eth2"]

EOF

# cmd:
# [root@2204 36-tcp-reassembled-PDU]$ lo clab-tcp-reassembled-pdu-server1 bash 
# [root@server1 /]# curl 10.1.8.10 
# PodName: server2 | PodIP: eth0 172.20.20.4/24

# How to calculate Packet Length: 
Len(spec_packet)=Len(TCP payload) + Len(TCP header) + Len(IP header) + Len(Ethernet header)
    2476        =2408             + 32              + 20             + 16
# All the details can be found below demo:
Frame 2039: 2476 bytes on wire (19808 bits), 2492 bytes captured (19936 bits)
Linux cooked capture v1
Internet Protocol Version 4, Src: 10.2.19.94, Dst: 10.2.148.26
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
    Total Length: 2460
    Identification: 0xc394 (50068)
    010. .... = Flags: 0x2, Don't fragment
    ...0 0000 0000 0000 = Fragment Offset: 0
    Time to Live: 64
    Protocol: TCP (6)
    Header Checksum: 0xb24b [validation disabled]
    [Header checksum status: Unverified]
    Source Address: 10.2.19.94
    Destination Address: 10.2.148.26
Transmission Control Protocol, Src Port: 9020, Dst Port: 5060, Seq: 1, Ack: 1, Len: 2408
    Source Port: 9020
    Destination Port: 5060
    [Stream index: 131]
    [Conversation completeness: Complete, WITH_DATA (31)]
    [TCP Segment Len: 2408]
    Sequence Number: 1    (relative sequence number)
    Sequence Number (raw): 714966270
    [Next Sequence Number: 2409    (relative sequence number)]
    Acknowledgment Number: 1    (relative ack number)
    Acknowledgment number (raw): 315492679
    1000 .... = Header Length: 32 bytes (8)
    Flags: 0x018 (PSH, ACK)
    Window: 453
    [Calculated window size: 28992]
    [Window size scaling factor: 64]
    Checksum: 0xc50a [unverified]
    [Checksum Status: Unverified]
    Urgent Pointer: 0
    Options: (12 bytes), No-Operation (NOP), No-Operation (NOP), Timestamps
    [Timestamps]
    [SEQ/ACK analysis]
    TCP payload (2408 bytes)
Session Initiation Protocol (INVITE)

