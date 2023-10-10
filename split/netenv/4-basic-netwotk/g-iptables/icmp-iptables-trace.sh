iptables -t raw     -$1 PREROUTING  -p ${2:-'tcp'} -j LOG --log-prefix "target hit raw.prerouting>"
iptables -t mangle  -$1 PREROUTING  -p ${2:-'tcp'} -j LOG --log-prefix "target hit mangle.prerouting>"
iptables -t nat     -$1 PREROUTING  -p ${2:-'tcp'} -j LOG --log-prefix "tagert hit nat.prerouting>"
iptables -t mangle  -$1 INPUT       -p ${2:-'tcp'} -j LOG --log-prefix "target hit mangle.input>"
iptables -t filter  -$1 INPUT       -p ${2:-'tcp'} -j LOG --log-prefix "target hit filter.input>"
iptables -t raw     -$1 OUTPUT      -p ${2:-'tcp'} -j LOG --log-prefix "target hit raw.output>"
iptables -t mangle  -$1 OUTPUT      -p ${2:-'tcp'} -j LOG --log-prefix "target hit mangle.output>"
iptables -t nat     -$1 OUTPUT      -p ${2:-'tcp'} -j LOG --log-prefix "target hit nat.output>"
iptables -t filter  -$1 OUTPUT      -p ${2:-'tcp'} -j LOG --log-prefix "target hit filter.output>"
iptables -t mangle  -$1 FORWARD     -p ${2:-'tcp'} -j LOG --log-prefix "target hit mangle.forward>"
iptables -t filter  -$1 FORWARD     -p ${2:-'tcp'} -j LOG --log-prefix "target hit filter.forward>"
iptables -t mangle  -$1 POSTROUTING -p ${2:-'tcp'} -j LOG --log-prefix "target hit mangle.postrouting>"
iptables -t nat     -$1 POSTROUTING -p ${2:-'tcp'} -j LOG --log-prefix "target hit nat.postrouting>"

if [ $1 == D ];then iptables-save | grep hit;fi

