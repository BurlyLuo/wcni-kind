[root@server1 /]# tcpdump -pne -i net0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on net0, link-type EN10MB (Ethernet), capture size 262144 bytes
07:50:14.045245 aa:c1:ab:58:73:1e > Broadcast, ethertype ARP (0x0806), length 42: Request who-has 10.1.5.1 tell 10.1.5.10, length 28
07:50:14.045305 aa:c1:ab:77:c8:31 > aa:c1:ab:58:73:1e, ethertype ARP (0x0806), length 42: Reply 10.1.5.1 is-at aa:c1:ab:77:c8:31, length 28
07:50:14.045310 aa:c1:ab:58:73:1e > aa:c1:ab:77:c8:31, ethertype IPv4 (0x0800), length 74: 10.1.5.10.58214 > 10.1.8.10.http: Flags [S], seq 313951433, win 56760, options [mss 9460,sackOK,TS val 2892298457 ecr 0,nop,wscale 7], length 0
07:50:14.045417 aa:c1:ab:77:c8:31 > aa:c1:ab:58:73:1e, ethertype IPv4 (0x0800), length 74: 10.1.8.10.http > 10.1.5.10.58214: Flags [S.], seq 3296027257, ack 313951434, win 56688, options [mss 9460,sackOK,TS val 2172400869 ecr 2892298457,nop,wscale 7], length 0
07:50:14.045430 aa:c1:ab:58:73:1e > aa:c1:ab:77:c8:31, ethertype IPv4 (0x0800), length 66: 10.1.5.10.58214 > 10.1.8.10.http: Flags [.], ack 1, win 444, options [nop,nop,TS val 2892298457 ecr 2172400869], length 0
07:50:14.045503 aa:c1:ab:58:73:1e > aa:c1:ab:77:c8:31, ethertype IPv4 (0x0800), length 139: 10.1.5.10.58214 > 10.1.8.10.http: Flags [P.], seq 1:74, ack 1, win 444, options [nop,nop,TS val 2892298457 ecr 2172400869], length 73: HTTP: GET / HTTP/1.1
07:50:14.045521 aa:c1:ab:77:c8:31 > aa:c1:ab:58:73:1e, ethertype IPv4 (0x0800), length 66: 10.1.8.10.http > 10.1.5.10.58214: Flags [.], ack 74, win 443, options [nop,nop,TS val 2172400869 ecr 2892298457], length 0
07:50:14.045729 aa:c1:ab:77:c8:31 > aa:c1:ab:58:73:1e, ethertype IPv4 (0x0800), length 302: 10.1.8.10.http > 10.1.5.10.58214: Flags [P.], seq 1:237, ack 74, win 443, options [nop,nop,TS val 2172400870 ecr 2892298457], length 236: HTTP: HTTP/1.1 200 OK
07:50:14.045749 aa:c1:ab:58:73:1e > aa:c1:ab:77:c8:31, ethertype IPv4 (0x0800), length 66: 10.1.5.10.58214 > 10.1.8.10.http: Flags [.], ack 237, win 443, options [nop,nop,TS val 2892298458 ecr 2172400870], length 0
07:50:14.045795 aa:c1:ab:77:c8:31 > aa:c1:ab:58:73:1e, ethertype IPv4 (0x0800), length 112: 10.1.8.10.http > 10.1.5.10.58214: Flags [P.], seq 237:283, ack 74, win 443, options [nop,nop,TS val 2172400870 ecr 2892298458], length 46: HTTP
07:50:14.045811 aa:c1:ab:58:73:1e > aa:c1:ab:77:c8:31, ethertype IPv4 (0x0800), length 66: 10.1.5.10.58214 > 10.1.8.10.http: Flags [.], ack 283, win 443, options [nop,nop,TS val 2892298458 ecr 2172400870], length 0
07:50:14.045884 aa:c1:ab:58:73:1e > aa:c1:ab:77:c8:31, ethertype IPv4 (0x0800), length 66: 10.1.5.10.58214 > 10.1.8.10.http: Flags [F.], seq 74, ack 283, win 443, options [nop,nop,TS val 2892298458 ecr 2172400870], length 0
07:50:14.045983 aa:c1:ab:77:c8:31 > aa:c1:ab:58:73:1e, ethertype IPv4 (0x0800), length 66: 10.1.8.10.http > 10.1.5.10.58214: Flags [F.], seq 283, ack 75, win 443, options [nop,nop,TS val 2172400870 ecr 2892298458], length 0
07:50:14.046006 aa:c1:ab:58:73:1e > aa:c1:ab:77:c8:31, ethertype IPv4 (0x0800), length 66: 10.1.5.10.58214 > 10.1.8.10.http: Flags [.], ack 284, win 443, options [nop,nop,TS val 2892298458 ecr 2172400870], length 0
^C
14 packets captured
14 packets received by filter
0 packets dropped by kernel
[root@server1 /]# 

