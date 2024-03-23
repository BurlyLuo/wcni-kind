#!md
apt install clang
apt --fix-broken install
apt install clang
apt install llvm
apt install pkg-config
apt install m4
apt install libelf-dev
apt install libpcap-dev
apt-get install -y gcc-multilib
apt-get install make

wget https://github.com/xdp-project/xdp-tools/releases/download/v1.4.2/xdp-tools-1.4.2.tar.gz
tar -xzvf xdp-tools-1.4.2.tar.gz
cd xdp-tools-1.4.2/
./configure 
make 

# 1. Capture pcap with xdpdump and tcpdump
/root/xdp-tools-1.4.2/xdp-dump/xdpdump -i ens3 -w xdpdump.cap
tcpdump -i ens3 -w tcpdump.cap

# 2. Make a test: [FAQ]
10.241.245.1:xxxx->10.241.245.155:32000->10.241.245.20[PodName: wluo-ntf7w | PodIP: eth0 10.0.2.239/32 | HostIP: 10.241.245.20]
# curl $controller_node_ip:32000
curl 10.241.245.155:32000
PodName: wluo-ntf7w | PodIP: eth0 10.0.2.239/32 | HostIP: 10.241.245.20

# 2.1: Capture the pcap
root@vmk0:~/xdp-tools-1.4.2/xdp-dump# ps -ef | grep xdpdump
root        9432    9330  0 15:06 pts/0    00:00:00 /root/xdp-tools-1.4.2/xdp-dump/xdpdump -i ens3 -w xdpdump.cap
root        9506    9330  0 15:07 pts/0    00:00:00 grep --color=auto xdpdump
root@vmk0:~/xdp-tools-1.4.2/xdp-dump# kill -9 9432
root@vmk0:~/xdp-tools-1.4.2/xdp-dump# ps -ef | grep tcpdump 
tcpdump     9435    9330  0 15:07 pts/0    00:00:00 tcpdump -i ens3 -w tcpdump.cap
root        9508    9330  0 15:07 pts/0    00:00:00 grep --color=auto tcpdump
[1]-  Killed                  /root/xdp-tools-1.4.2/xdp-dump/xdpdump -i ens3 -w xdpdump.cap
root@vmk0:~/xdp-tools-1.4.2/xdp-dump# kill -9 9435
root@vmk0:~/xdp-tools-1.4.2/xdp-dump# 
[2]+  Killed                  tcpdump -i ens3 -w tcpdump.cap
root@vmk0:~/xdp-tools-1.4.2/xdp-dump# 

FAQ:
Note that packets which have been pushed back out of the device for NodePort handling right at the XDP layer are not visible in tcpdump since packet taps come at a much later stage in the networking stack. Cilium’s monitor command or metric counters can be used instead for gaining visibility.
