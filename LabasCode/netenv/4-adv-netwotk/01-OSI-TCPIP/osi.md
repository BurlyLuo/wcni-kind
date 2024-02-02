Frame 15: 70 bytes on wire (560 bits), 70 bytes captured (560 bits)
    Encapsulation type: Ethernet (1)
    Arrival Time: Apr 10, 2023 16:56:51.162025000 China Standard Time
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1681117011.162025000 seconds
    [Time delta from previous captured frame: 0.000049000 seconds]
    [Time delta from previous displayed frame: 0.000049000 seconds]
    [Time since reference or first frame: 3.012186000 seconds]
    Frame Number: 15
    Frame Length: 70 bytes (560 bits)
    Capture Length: 70 bytes (560 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: eth:ethertype:ip:tcp]
    [Coloring Rule Name: HTTP]
    [Coloring Rule String: http || tcp.port == 80 || http2]
Ethernet II, Src: 02:42:ac:12:00:02 (02:42:ac:12:00:02), Dst: 02:42:ac:12:00:03 (02:42:ac:12:00:03)
    Destination: 02:42:ac:12:00:03 (02:42:ac:12:00:03)
        Address: 02:42:ac:12:00:03 (02:42:ac:12:00:03)
        .... ..1. .... .... .... .... = LG bit: Locally administered address (this is NOT the factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Source: 02:42:ac:12:00:02 (02:42:ac:12:00:02)
        Address: 02:42:ac:12:00:02 (02:42:ac:12:00:02)
        .... ..1. .... .... .... .... = LG bit: Locally administered address (this is NOT the factory default)
        .... ...0 .... .... .... .... = IG bit: Individual address (unicast)
    Type: IPv4 (0x0800)
Internet Protocol Version 4, Src: 172.18.0.2, Dst: 10.244.1.2
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
        0000 00.. = Differentiated Services Codepoint: Default (0)
        .... ..00 = Explicit Congestion Notification: Not ECN-Capable Transport (0)
    Total Length: 56
    Identification: 0xe1a7 (57767)
    Flags: 0x40, Don't fragment
        0... .... = Reserved bit: Not set
        .1.. .... = Don't fragment: Set
        ..0. .... = More fragments: Not set
    ...0 0000 0000 0000 = Fragment Offset: 0
    Time to Live: 63
    Protocol: TCP (6)
    Header Checksum: 0xa20e [validation disabled]
    [Header checksum status: Unverified]
    Source Address: 172.18.0.2
    Destination Address: 10.244.1.2
Transmission Control Protocol, Src Port: 23436, Dst Port: 80, Seq: 1, Ack: 1, Len: 4
    Source Port: 23436
    Destination Port: 80
    [Stream index: 4]
    [Conversation completeness: Incomplete (12)]
    [TCP Segment Len: 4]
    Sequence Number: 1    (relative sequence number)
    Sequence Number (raw): 3053590443
    [Next Sequence Number: 5    (relative sequence number)]
    Acknowledgment Number: 1    (relative ack number)
    Acknowledgment number (raw): 1995855337
    1000 .... = Header Length: 32 bytes (8)
    Flags: 0x018 (PSH, ACK)
        000. .... .... = Reserved: Not set
        ...0 .... .... = Nonce: Not set
        .... 0... .... = Congestion Window Reduced (CWR): Not set
        .... .0.. .... = ECN-Echo: Not set
        .... ..0. .... = Urgent: Not set
        .... ...1 .... = Acknowledgment: Set
        .... .... 1... = Push: Set
        .... .... .0.. = Reset: Not set
        .... .... ..0. = Syn: Not set
        .... .... ...0 = Fin: Not set
        [TCP Flags: ·······AP···]
    Window: 502
    [Calculated window size: 502]
    [Window size scaling factor: -1 (unknown)]
    Checksum: 0xb834 [unverified]
    [Checksum Status: Unverified]
    Urgent Pointer: 0
    Options: (12 bytes), No-Operation (NOP), No-Operation (NOP), Timestamps
        TCP Option - No-Operation (NOP)
            Kind: No-Operation (1)
        TCP Option - No-Operation (NOP)
            Kind: No-Operation (1)
        TCP Option - Timestamps: TSval 1723006673, TSecr 1882341836
            Kind: Time Stamp Option (8)
            Length: 10
            Timestamp value: 1723006673
            Timestamp echo reply: 1882341836
    [Timestamps]
        [Time since first frame in this TCP stream: 0.000000000 seconds]
        [Time since previous frame in this TCP stream: 0.000000000 seconds]
    [SEQ/ACK analysis]
        [Bytes in flight: 4]
        [Bytes sent since last PSH flag: 4]
    TCP payload (4 bytes)

