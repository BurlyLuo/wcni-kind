2039	2024-04-19 17:53:45.929506	10.2.19.94	10.2.148.26	SIP/SDP	2476	5060	9020	131	Request: INVITE sip:18898710139@sha-st.mavenir.com | 

###
ethtool -K eth0 tso off lro off gso off gro off
###

Length: 2476
Frame 2039: 2476 bytes on wire (19808 bits), 2492 bytes captured (19936 bits)
    Encapsulation type: Linux cooked-mode capture v1 (25)
    Arrival Time: Apr 19, 2024 17:53:45.929506000 China Standard Time
    [Time shift for this packet: 0.000000000 seconds]
    Epoch Time: 1713520425.929506000 seconds
    [Time delta from previous captured frame: 0.033935000 seconds]
    [Time delta from previous displayed frame: 2.019785000 seconds]
    [Time since reference or first frame: 16.332078000 seconds]
    Frame Number: 2039
    Frame Length: 2476 bytes (19808 bits)
        [Expert Info (Error/Malformed): Frame length is less than captured length]
            [Frame length is less than captured length]
            [Severity level: Error]
            [Group: Malformed]
    Capture Length: 2492 bytes (19936 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: sll:ethertype:ip:tcp:sip:sdp]
    [Coloring Rule Name: TCP]
    [Coloring Rule String: tcp]
Linux cooked capture v1
    Packet type: Sent by us (4)
    Link-layer address type: Ethernet (1)
    Link-layer address length: 6
    Source: VMware_6b:ef:d4 (00:0c:29:6b:ef:d4)
    Unused: 0800
    Protocol: IPv4 (0x0800)
    Trailer: 98000000293f2266156e743734000000
Internet Protocol Version 4, Src: 10.2.19.94, Dst: 10.2.148.26
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
        0000 00.. = Differentiated Services Codepoint: Default (0)
        .... ..00 = Explicit Congestion Notification: Not ECN-Capable Transport (0)
    Total Length: 2460
    Identification: 0xc394 (50068)
    010. .... = Flags: 0x2, Don't fragment
        0... .... = Reserved bit: Not set
        .1.. .... = Don't fragment: Set
        ..0. .... = More fragments: Not set
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
        000. .... .... = Reserved: Not set
        ...0 .... .... = Accurate ECN: Not set
        .... 0... .... = Congestion Window Reduced: Not set
        .... .0.. .... = ECN-Echo: Not set
        .... ..0. .... = Urgent: Not set
        .... ...1 .... = Acknowledgment: Set
        .... .... 1... = Push: Set
        .... .... .0.. = Reset: Not set
        .... .... ..0. = Syn: Not set
        .... .... ...0 = Fin: Not set
        [TCP Flags: ·······AP···]
    Window: 453
    [Calculated window size: 28992]
    [Window size scaling factor: 64]
    Checksum: 0xc50a [unverified]
    [Checksum Status: Unverified]
    Urgent Pointer: 0
    Options: (12 bytes), No-Operation (NOP), No-Operation (NOP), Timestamps
        TCP Option - No-Operation (NOP)
            Kind: No-Operation (1)
        TCP Option - No-Operation (NOP)
            Kind: No-Operation (1)
        TCP Option - Timestamps
            Kind: Time Stamp Option (8)
            Length: 10
            Timestamp value: 1363430233: TSval 1363430233, TSecr 2150375531
            Timestamp echo reply: 2150375531
    [Timestamps]
        [Time since first frame in this TCP stream: 1.001756000 seconds]
        [Time since previous frame in this TCP stream: 1.000917000 seconds]
    [SEQ/ACK analysis]
        [iRTT: 0.000839000 seconds]
        [Bytes in flight: 2408]
        [Bytes sent since last PSH flag: 2408]
    TCP payload (2408 bytes)
Session Initiation Protocol (INVITE)
    Request-Line: INVITE sip:18898710139@sha-st.mavenir.com SIP/2.0
        Method: INVITE
        Request-URI: sip:18898710139@sha-st.mavenir.com
            Request-URI User Part: 18898710139
            Request-URI Host Part: sha-st.mavenir.com
        [Resent Packet: False]
    Message Header
        Via: SIP/2.0/TCP 10.2.19.94:9020;branch=z9hG4bK-18450-1-0
            Transport: TCP
            Sent-by Address: 10.2.19.94
            Sent-by port: 9020
            Branch: z9hG4bK-18450-1-0
        Max-Forwards: 70
        Call-ID: 2000///22222
        [Generated Call-ID: 2000///22222]
        From: <sip:18898710138@sha-st.mavenir.com>;tag=18450SIPpTag021
            SIP from address: sip:18898710138@sha-st.mavenir.com
                SIP from address User Part: 18898710138
                SIP from address Host Part: sha-st.mavenir.com
            SIP from tag: 18450SIPpTag021
        To: <sip:18898710139@sha-st.mavenir.com>
            SIP to address: sip:18898710139@sha-st.mavenir.com
                SIP to address User Part: 18898710139
                SIP to address Host Part: sha-st.mavenir.com
        CSeq: 1 INVITE
            Sequence Number: 1
            Method: INVITE
        Allow: INVITE,ACK,CANCEL,OPTIONS,NOTIFY,PRACK,UPDATE,BYE
        Supported: histinfo,precondition,100rel,timer
        P-Asserted-Identity:<sip:+491715905945;cpc=ordinary@bgcf.mavenir.com;user=phone>,<tel:+491715905945;cpc=ordinary>
            SIP PAI Address: sip:+491715905945;cpc=ordinary@bgcf.mavenir.com;user=phone
                SIP PAI User Part: +491715905945;cpc=ordinary
                E.164 number (MSISDN): 491715905945;cpc=ordinary
                    Country Code: Germany (Federal Republic of) (49)
                SIP PAI Host Part: bgcf.mavenir.com
                SIP PAI URI parameter: user=phone
        P-Early-Media: supported
        P-Access-Network-Info: IEEE-802.11;i-wlan-node-id=ffffffffffff;"ETinT"
            access-type: IEEE-802.11
            i-wlan-node-id=ffffffffffff
            "ETinT"
        User-Agent: SIPPdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
        P-Charging-Vector: icid-value=BON-ECAT741-M0-S11-S15.ims.telekom.de-1479-735236-892685;icid-generated-at=BON-ECAT741-M0-S11-S15.ims.telekom.de;orig-ioi=10.144.34.8
            icid-value: BON-ECAT741-M0-S11-S15.ims.telekom.de-1479-735236-892685
            icid-generated-at=BON-ECAT741-M0-S11-S15.ims.telekom.de
            orig-ioi=10.144.34.8
        Contact: <sip:18898710138@10.2.19.94:9020>
            Contact URI: sip:18898710138@10.2.19.94:9020
                Contact URI User Part: 18898710138
                Contact URI Host Part: 10.2.19.94
                Contact URI Host Port: 9020
        Accept-Contact:*;+g.3gpp.icsi-ref="urn%3Aurn-7%3A3gpp-service.ims.icsi.mmtel"
        P-Mav-Extension-Correlation-ID: a00060047308000004e9c
            [Expert Info (Note/Undecoded): Unrecognised SIP header (p-mav-extension-correlation-id)]
                [Unrecognised SIP header (p-mav-extension-correlation-id)]
                [Severity level: Note]
                [Group: Undecoded]
        Record-Route: <sip:mavodi-0-155-6-1-250100-9eb00000-615918fa24059-5a0001-ffffffffffffffff-@ca1ecscf01.ims.mnc150.mcc302.3gppnetwork.org:5070;lr>,<sip:mavodi-0-266-1f-8-ffffffff-64210000-615918fb6fcf8-5a0001-ffffffffffffffff-mav>
            Record-Route URI: sip:mavodi-0-155-6-1-250100-9eb00000-615918fa24059-5a0001-ffffffffffffffff-@ca1ecscf01.ims.mnc150.mcc302.3gppnetwork.org:5070;lr
                Record-Route Userinfo: mavodi-0-155-6-1-250100-9eb00000-615918fa24059-5a0001-ffffffffffffffff-
                Record-Route Host Part: ca1ecscf01.ims.mnc150.mcc302.3gppnetwork.org
                Record-Route Host Port: 5070
                Record-Route URI parameter: lr
            Record-Route URI: sip:mavodi-0-266-1f-8-ffffffff-64210000-615918fb6fcf8-5a0001-ffffffffffffffff-mav
                Record-Route Host Part: mavodi-0-266-1f-8-ffffffff-64210000-615918fb6fcf8-5a0001-ffffffffffffffff-mav
        P-Charging-Vector: icid-value=0.614.31-1713380924.85905;orig-ioi=e-ioi2;icid-generated-at=10.250.110.18
            icid-value: 0.614.31-1713380924.85905
            orig-ioi=e-ioi2
            icid-generated-at=10.250.110.18
        P-Charging-Function-Addresses: ccf=pc.mav.lab;ccf=sc.mav.lab;ecf=pe.mav.lab;ecf=se.mav.lab
            ccf=pc.mav.lab
            ccf=sc.mav.lab
            ecf=pe.mav.lab
            ecf=se.mav.lab
        P-Asserted-Identity: <sip:+13672230302@ims.mnc150.mcc302.3gppnetwork.org;X-ST-IMSI=302150001000022;user=phone>,tel:+13672230302
            SIP PAI Address: sip:+13672230302@ims.mnc150.mcc302.3gppnetwork.org;X-ST-IMSI=302150001000022;user=phone
                SIP PAI User Part: +13672230302
                E.164 number (MSISDN): 13672230302
                    Country Code: Americas (1)
                SIP PAI Host Part: ims.mnc150.mcc302.3gppnetwork.org
                SIP PAI URI parameter: X-ST-IMSI=302150001000022
                SIP PAI URI parameter: user=phone
        P-Access-Network-Info:3GPP-E-UTRAN-FDD;utran-cell-id-3gpp=26201003d1b70601
            access-type: 3GPP-E-UTRAN-FDD
            utran-cell-id-3gpp: 26201003d1b70601
        Content-Type: application/sdp
        Content-Length:   690
    Message Body
        Session Description Protocol
            Session Description Protocol Version (v): 0
            Owner/Creator, Session Id (o): - 31071 1 IN IP4 10.2.19.94
                Owner Username: -
                Session ID: 31071
                Session Version: 1
                Owner Network Type: IN
                Owner Address Type: IP4
                Owner Address: 10.2.19.94
            Session Name (s): VMD
            Connection Information (c): IN IP4 10.2.19.94
                Connection Network Type: IN
                Connection Address Type: IP4
                Connection Address: 10.2.19.94
            Time Description, active time (t): 0 0
                Session Start Time: 0
                Session Stop Time: 0
            Media Description, name and address (m): audio 9000 RTP/AVP 116 107 9 118 96 111 110 8 0
                Media Type: audio
                Media Port: 9000
                Media Protocol: RTP/AVP
                Media Format: DynamicRTP-Type-116
                Media Format: DynamicRTP-Type-107
                Media Format: ITU-T G.722
                Media Format: DynamicRTP-Type-118
                Media Format: DynamicRTP-Type-96
                Media Format: DynamicRTP-Type-111
                Media Format: DynamicRTP-Type-110
                Media Format: ITU-T G.711 PCMA
                Media Format: ITU-T G.711 PCMU
            Bandwidth Information (b): AS:80
                Bandwidth Modifier: AS [Application Specific (RTP session bandwidth)]
                Bandwidth Value: 80 kb/s
            Bandwidth Information (b): RS:612
                Bandwidth Modifier: RS
                Bandwidth Value: 612
            Bandwidth Information (b): RR:1837
                Bandwidth Modifier: RR
                Bandwidth Value: 1837
            Media Attribute (a): rtpmap:116 AMR-WB/16000/1
                Media Attribute Fieldname: rtpmap
                Media Format: 116
                MIME Type: AMR-WB
                Sample Rate: 16000
            Media Attribute (a): fmtp:116 mode-change-capability=2; max-red=0
                Media Attribute Fieldname: fmtp
                Media Format: 116 [AMR-WB]
                Media format specific parameters: mode-change-capability=2
                Media format specific parameters: max-red=0
            Media Attribute (a): rtpmap:107 AMR-WB/16000/1
                Media Attribute Fieldname: rtpmap
                Media Format: 107
                MIME Type: AMR-WB
                Sample Rate: 16000
            Media Attribute (a): fmtp:107 octet-align=1; mode-change-capability=2; max-red=0
                Media Attribute Fieldname: fmtp
                Media Format: 107 [AMR-WB]
                Media format specific parameters: octet-align=1
                Media format specific parameters: mode-change-capability=2
                Media format specific parameters: max-red=0
            Media Attribute (a): rtpmap:9 G722/8000
                Media Attribute Fieldname: rtpmap
                Media Format: 9
                MIME Type: G722
                Sample Rate: 8000 (RTP clock rate is 8kHz, actual sampling rate is 16kHz)
            Media Attribute (a): rtpmap:118 AMR/8000/1
                Media Attribute Fieldname: rtpmap
                Media Format: 118
                MIME Type: AMR
                Sample Rate: 8000
            Media Attribute (a): fmtp:118 mode-change-capability=2; max-red=0
                Media Attribute Fieldname: fmtp
                Media Format: 118 [AMR]
                Media format specific parameters: mode-change-capability=2
                Media format specific parameters: max-red=0
            Media Attribute (a): rtpmap:96 AMR/8000/1
                Media Attribute Fieldname: rtpmap
                Media Format: 96
                MIME Type: AMR
                Sample Rate: 8000
            Media Attribute (a): fmtp:96 octet-align=1; mode-change-capability=2; max-red=0
                Media Attribute Fieldname: fmtp
                Media Format: 96 [AMR]
                Media format specific parameters: octet-align=1
                Media format specific parameters: mode-change-capability=2
                Media format specific parameters: max-red=0
            Media Attribute (a): rtpmap:111 telephone-event/16000
                Media Attribute Fieldname: rtpmap
                Media Format: 111
                MIME Type: telephone-event
                Sample Rate: 16000
            Media Attribute (a): fmtp:111 0-15
                Media Attribute Fieldname: fmtp
                Media Format: 111 [telephone-event]
                Media format specific parameters: 0-15
            Media Attribute (a): rtpmap:110 telephone-event/8000
                Media Attribute Fieldname: rtpmap
                Media Format: 110
                MIME Type: telephone-event
                Sample Rate: 8000
            Media Attribute (a): fmtp:110 0-15
                Media Attribute Fieldname: fmtp
                Media Format: 110 [telephone-event]
                Media format specific parameters: 0-15
            Media Attribute (a): sendrecv
            Media Attribute (a): ptime:20
                Media Attribute Fieldname: ptime
                Media Attribute Value: 20
            Media Attribute (a): maxptime:40
                Media Attribute Fieldname: maxptime
                Media Attribute Value: 40
            Media Attribute (a): rtpmap:8 PCMA/8000
                Media Attribute Fieldname: rtpmap
                Media Format: 8
                MIME Type: PCMA
                Sample Rate: 8000
            Media Attribute (a): rtpmap:0 PCMU/8000
                Media Attribute Fieldname: rtpmap
                Media Format: 0
                MIME Type: PCMU
                Sample Rate: 8000
            [Generated Call-ID: 2000///22222]

