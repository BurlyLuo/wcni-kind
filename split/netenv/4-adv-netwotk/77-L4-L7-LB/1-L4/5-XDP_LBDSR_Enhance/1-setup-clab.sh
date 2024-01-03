#!/bin/bash
set -v

docker run -td -h xdpdsrlb --privileged --name xdpdsrlb 192.168.2.100:5000/ebpf-xdp:v03
docker exec xdpdsrlb bash -c "git clone https://github.com/snpsuen/XDP_LBDSR_Enhance && cd XDP_LBDSR_Enhance && make"

tail -f  /sys/kernel/debug/tracing/trace_pipe > xdpdsrlb.trace >/dev/null 2>&1 &

docker run -td --privileged --name backend_a -h backend-A 192.168.2.100:5000/nettool
docker run -td --privileged --name backend_b -h backend-B 192.168.2.100:5000/nettool
docker exec backend_a bash -c "ip addr add 192.168.25.10/24 dev lo"
docker exec backend_b bash -c "ip addr add 192.168.25.10/24 dev lo"

docker run -td --privileged --name client -h client 192.168.2.100:5000/nettool
docker exec client bash -c "ip route add 192.168.25.10/32 via 172.17.0.2"

# make a test:
echo backend_a_ip=$(docker exec -it backend_a ip a s eth0 | grep inet | awk -F "/" '{print $1}' | awk -F " " '{print $2}')
echo backend_a_mac=$(docker exec -it backend_a ip l show eth0 | grep "link/ether" | awk '{print $2}')
echo backend_b_ip=$(docker exec -it backend_b ip a s eth0 | grep inet | awk -F "/" '{print $1}' | awk -F " " '{print $2}')
echo backend_b_mac=$(docker exec -it backend_b ip l show eth0 | grep "link/ether" | awk '{print $2}')

echo xdpdsrlb_ip=$(docker exec -it xdpdsrlb ip a s eth0 | grep inet | awk -F "/" '{print $1}' | awk -F " " '{print $2}')
echo xdpdsrlb_mac=$(docker exec -it xdpdsrlb ip l show eth0 | grep "link/ether" | awk '{print $2}')

docker exec -it xdpdsrlb bash
cd XDP_LBDSR*
./xdp_lbdsr

while true;do curl -s http://192.168.25.10;sleep 1;done

kill -9 $(pidof tail)
