#!/bin/bash
if [[ $# -lt 2 ]];then echo "./icmp-iptables-trace.sh I icmp"$'\n'"./icmp-iptables-trace.sh D icmp";exit 1;fi

iptables -t raw     -$1 PREROUTING  -p ${2:-'icmp'} -j LOG --log-prefix "t_hit prerouting>"
iptables -t mangle  -$1 PREROUTING  -p ${2:-'icmp'} -j LOG --log-prefix "t_hit mangle.prerouting>"
iptables -t nat     -$1 PREROUTING  -p ${2:-'icmp'} -j LOG --log-prefix "t_hit nat.prerouting>"
iptables -t mangle  -$1 INPUT       -p ${2:-'icmp'} -j LOG --log-prefix "t_hit mangle.input>"
iptables -t filter  -$1 INPUT       -p ${2:-'icmp'} -j LOG --log-prefix "t_hit filter.input>"
iptables -t raw     -$1 OUTPUT      -p ${2:-'icmp'} -j LOG --log-prefix "t_hit raw.output>"
iptables -t mangle  -$1 OUTPUT      -p ${2:-'icmp'} -j LOG --log-prefix "t_hit mangle.output>"
iptables -t nat     -$1 OUTPUT      -p ${2:-'icmp'} -j LOG --log-prefix "t_hit nat.output>"
iptables -t filter  -$1 OUTPUT      -p ${2:-'icmp'} -j LOG --log-prefix "t_hit filter.output>"
iptables -t mangle  -$1 FORWARD     -p ${2:-'icmp'} -j LOG --log-prefix "t_hit mangle.forward>"
iptables -t filter  -$1 FORWARD     -p ${2:-'icmp'} -j LOG --log-prefix "t_hit filter.forward>"
iptables -t mangle  -$1 POSTROUTING -p ${2:-'icmp'} -j LOG --log-prefix "t_hit mangle.postrouting>"
iptables -t nat     -$1 POSTROUTING -p ${2:-'icmp'} -j LOG --log-prefix "t_hit nat.postrouting>"

if [ $1 == D ];then iptables-save | grep hit;fi

