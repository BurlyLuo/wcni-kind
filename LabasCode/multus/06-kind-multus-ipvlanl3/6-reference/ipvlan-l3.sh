# IPVLAN L3:
# 1.Add ns：
ip netns add net1
ip netns add net2
# 2. Set the ipvlan l3 mode:
ip link add ipvlan1 link ens160 type ipvlan mode l3
ip link add ipvlan2 link ens160 type ipvlan mode l3
# 3.Add the interface to ns:
ip link set ipvlan1 netns net1
ip link set ipvlan2 netns net2
# 4.config the ip address
ip netns exec net1 ifconfig ipvlan1 10.1.1.2/24 up
ip netns exec net2 ifconfig ipvlan2 10.1.2.2/24 up
# 5.Add default route
ip netns exec net1 ip route add default dev ipvlan1
ip netns exec net2 ip route add default dev ipvlan2

