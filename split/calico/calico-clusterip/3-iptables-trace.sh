#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: ./3-iptables-trace.sh I sport 9494 tcp"
    exit
fi
iptables -t raw     -$1 PREROUTING  -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit raw.prerouting>"
iptables -t mangle  -$1 PREROUTING  -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit mangle.prerouting>"
iptables -t nat     -$1 PREROUTING  -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni tagert hit nat.prerouting>"
iptables -t mangle  -$1 INPUT       -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit mangle.input>"
iptables -t filter  -$1 INPUT       -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit filter.input>"
iptables -t raw     -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit raw.output>"
iptables -t mangle  -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit mangle.output>"
iptables -t nat     -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit nat.output>"
iptables -t filter  -$1 OUTPUT      -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit filter.output>"
iptables -t mangle  -$1 FORWARD     -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit mangle.forward>"
iptables -t filter  -$1 FORWARD     -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit filter.forward>"
iptables -t mangle  -$1 POSTROUTING -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit mangle.postrouting>"
iptables -t nat     -$1 POSTROUTING -p ${4:-'tcp'}  --$2 $3 -j LOG --log-prefix "wluo-cni target hit nat.postrouting>"

if [ $1 == D ];then iptables-save | grep hit;fi

