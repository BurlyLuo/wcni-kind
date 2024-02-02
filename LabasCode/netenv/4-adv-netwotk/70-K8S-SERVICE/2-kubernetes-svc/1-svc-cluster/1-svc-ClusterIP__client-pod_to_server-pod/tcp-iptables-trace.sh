#!/bin/bash
if [[ $# -lt 4 ]];then
  echo "Usage:"
  echo "./tcp-iptables-trace.sh I sport 9495 tcp"
  echo "./tcp-iptables-trace.sh I dport 9495 tcp"
  echo "./tcp-iptables-trace.sh I sport 54321 tcp"
  echo "./tcp-iptables-trace.sh I dport 54321 tcp"
  exit
fi

iptables -t raw     -$1 PREROUTING  -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit raw.prerouting>"
iptables -t mangle  -$1 PREROUTING  -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit mangle.prerouting>"
iptables -t nat     -$1 PREROUTING  -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit nat.prerouting>"
iptables -t mangle  -$1 INPUT       -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit mangle.input>"
iptables -t filter  -$1 INPUT       -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit filter.input>"
iptables -t raw     -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit raw.output>"
iptables -t mangle  -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit mangle.output>"
iptables -t nat     -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit nat.output>"
iptables -t filter  -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit filter.output>"
iptables -t mangle  -$1 FORWARD     -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit mangle.forward>"
iptables -t filter  -$1 FORWARD     -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit filter.forward>"
iptables -t mangle  -$1 POSTROUTING -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit mangle.postrouting>"
iptables -t nat     -$1 POSTROUTING -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "t_hit nat.postrouting>"

if [ $1 == D ];then iptables-save | grep hit;fi

