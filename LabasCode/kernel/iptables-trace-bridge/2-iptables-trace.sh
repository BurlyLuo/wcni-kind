#!/bin/bash
if [ -z "$1" ]; then
    echo 'Usage: ./3-iptables-trace.sh I icmp'
    exit
fi

iptables -t raw     -$1 PREROUTING  -p ${2:-'icmp'}  -j LOG --log-prefix "Thit raw.prerouting>"
iptables -t mangle  -$1 PREROUTING  -p ${2:-'icmp'}  -j LOG --log-prefix "Thit mangle.prerouting>"
iptables -t nat     -$1 PREROUTING  -p ${2:-'icmp'}  -j LOG --log-prefix "Thit nat.prerouting>"
iptables -t mangle  -$1 INPUT       -p ${2:-'icmp'}  -j LOG --log-prefix "Thit mangle.input>"
iptables -t filter  -$1 INPUT       -p ${2:-'icmp'}  -j LOG --log-prefix "Thit filter.input>"
iptables -t raw     -$1 OUTPUT      -p ${2:-'icmp'}  -j LOG --log-prefix "Thit raw.output>"
iptables -t mangle  -$1 OUTPUT      -p ${2:-'icmp'}  -j LOG --log-prefix "Thit mangle.output>"
iptables -t nat     -$1 OUTPUT      -p ${2:-'icmp'}  -j LOG --log-prefix "Thit nat.output>"
iptables -t filter  -$1 OUTPUT      -p ${2:-'icmp'}  -j LOG --log-prefix "Thit filter.output>"
iptables -t mangle  -$1 FORWARD     -p ${2:-'icmp'}  -j LOG --log-prefix "Thit mangle.forward>"
iptables -t filter  -$1 FORWARD     -p ${2:-'icmp'}  -j LOG --log-prefix "Thit filter.forward>"
iptables -t mangle  -$1 POSTROUTING -p ${2:-'icmp'}  -j LOG --log-prefix "Thit mangle.postrouting>"
iptables -t nat     -$1 POSTROUTING -p ${2:-'icmp'}  -j LOG --log-prefix "Thit nat.postrouting>"

if [ $1 == D ];then iptables-save | grep hit;fi

