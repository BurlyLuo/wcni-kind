#!/bin/bash
echo "https://github.com/x-way/ipsecdump"
wget http://192.168.2.100/k3s/go/go1.23.2.linux-amd64.tar.gz -P / && tar -C /usr/local -xzf /go1.23.2.linux-amd64.tar.gz
export GOPATH=$HOME/go && export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct

wget http://192.168.2.100/k3s/go/ipsecdump.tgz -P / && tar -xzvf /ipsecdump.tgz && cd /ipsecdump-master && go build && cp -r /ipsecdump-master/ipsecdump /usr/bin/ && chmod +x /usr/bin/ipsecdump

echo -e "\nipsecdump ingress and egress traffic capture"
echo "ipsecdump -t 1000s -i eth2 -m transport
06:42:39.030623 IP 10.1.5.10.81 > 10.1.8.10.80: Flags [S], seq 967301172, win 56760, options [mss 9460,sackOK,TS val 1350515597 ecr 0,nop,wscale 7], length 0
06:42:39.030887 IP 10.1.8.10.80 > 10.1.5.10.81: Flags [S.], seq 106123370, ack 967301173, win 56688, options [mss 9460,sackOK,TS val 358497126 ecr 1350515597,nop,wscale 7], length 0
06:42:39.030972 IP 10.1.5.10.81 > 10.1.8.10.80: Flags [.], ack 106123371, win 444, options [nop,nop,TS val 1350515597 ecr 358497126], length 0
06:42:39.031004 IP 10.1.5.10.81 > 10.1.8.10.80: Flags [P.], seq 967301173:967301246, ack 106123371, win 444, options [nop,nop,TS val 1350515597 ecr 358497126], length 73
06:42:39.031016 IP 10.1.8.10.80 > 10.1.5.10.81: Flags [.], ack 967301246, win 443, options [nop,nop,TS val 358497126 ecr 1350515597], length 0
06:42:39.031026 IP 10.1.8.10.80 > 10.1.5.10.81: Flags [P.], seq 106123371:106123607, ack 967301246, win 443, options [nop,nop,TS val 358497127 ecr 1350515597], length 236
06:42:39.031061 IP 10.1.8.10.80 > 10.1.5.10.81: Flags [P.], seq 106123607:106123678, ack 967301246, win 443, options [nop,nop,TS val 358497127 ecr 1350515597], length 71
06:42:39.031071 IP 10.1.5.10.81 > 10.1.8.10.80: Flags [.], ack 106123607, win 443, options [nop,nop,TS val 1350515598 ecr 358497127], length 0
06:42:39.031081 IP 10.1.5.10.81 > 10.1.8.10.80: Flags [.], ack 106123678, win 443, options [nop,nop,TS val 1350515598 ecr 358497127], length 0
06:42:39.031107 IP 10.1.5.10.81 > 10.1.8.10.80: Flags [F.], seq 967301246, ack 106123678, win 443, options [nop,nop,TS val 1350515598 ecr 358497127], length 0
06:42:39.031119 IP 10.1.8.10.80 > 10.1.5.10.81: Flags [F.], seq 106123678, ack 967301247, win 443, options [nop,nop,TS val 358497128 ecr 1350515598], length 0
06:42:39.031128 IP 10.1.5.10.81 > 10.1.8.10.80: Flags [.], ack 106123679, win 443, options [nop,nop,TS val 1350515599 ecr 358497128], length 0
ipsec1~$"
