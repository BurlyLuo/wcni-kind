# 1. The Linux infrastructure can be setup by running this bash script:

#!/bin/bash

if [ $USER != "root" ] ; then
    echo "Restarting script with sudo..."
    sudo $0 ${*}
    exit
fi

# delete previous incarnations if they exist
ip link del dev veth_vpp1
ip link del dev veth_vpp2
ip netns del vpp1
ip netns del vpp2

#create namespaces
ip netns add vpp1
ip netns add vpp2

# create and configure 1st veth pair
ip link add name veth_vpp1 type veth peer name vpp1
ip link set dev vpp1 up
ip link set dev veth_vpp1 up netns vpp1

ip netns exec vpp1 \
  bash -c "
    ip link set dev lo up
    ip addr add 172.16.1.2/24 dev veth_vpp1
    ip route add 172.16.2.0/24 via 172.16.1.1
"

# create and configure 2st veth pair
ip link add name veth_vpp2 type veth peer name vpp2
ip link set dev vpp2 up
ip link set dev veth_vpp2 up netns vpp2

ip netns exec vpp2 \
  bash -c "
    ip link set dev lo up
    ip addr add 172.16.2.2/24 dev veth_vpp2
    ip route add 172.16.1.0/24 via 172.16.2.1
"

# 2. We need to configure VPP interface ip address and interface state:
vppctl create host-interface name vpp1
vppctl create host-interface name vpp2
vppctl set int state host-vpp1 up
vppctl set int state host-vpp2 up
vppctl set int ip address host-vpp1 172.16.1.1/24
vppctl set int ip address host-vpp2 172.16.2.1/24

# 3. We should now be able to send a ping from one namespace to another:
$ ip netns exec vpp1 ping 172.16.2.1 -c 1
PING 172.16.2.2 (172.16.2.2) 56(84) bytes of data.
64 bytes from 172.16.2.2: icmp_seq=1 ttl=63 time=0.135 ms

--- 172.16.2.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.135/0.135/0.135/0.000 ms

vpp# show ip arp
    Time      FIB        IP4      Stat      Ethernet              Interface
   1050.5729   0     172.16.1.2         5a:df:31:28:dc:5c         host-vpp1
   1050.5768   0     172.16.2.2         12:fa:19:cb:39:e3         host-vpp2

vpp# show interface
              Name               Idx       State          Counter          Count
host-vpp1                         5         up       rx packets                     1
                                                     rx bytes                      98
                                                     tx packets                     1
                                                     tx bytes                      98
                                                     ip4                            1
host-vpp2                         6         up       rx packets                     1
                                                     rx bytes                      98
                                                     tx packets                     1
                                                     tx bytes                      98
                                                     ip4                            1

