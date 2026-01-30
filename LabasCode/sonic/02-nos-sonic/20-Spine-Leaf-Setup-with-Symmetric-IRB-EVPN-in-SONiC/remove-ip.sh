for i in {0..124..4}; do ip_suffix=$((i/4*2)); sudo config interface ip remove Ethernet${i} 10.0.0.${ip_suffix}/31; done
