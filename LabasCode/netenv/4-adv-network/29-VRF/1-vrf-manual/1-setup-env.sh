# https://docs.kernel.org/networking/vrf.html
#node0：
#        tap0---vrf0---veth0=======veth1---vrf1---tap1
#
#        tap0: 172.18.1.2/24
#        tap1: 172.18.2.2/24

# 创建vrf0拓扑
ip link add dev vrf0 type vrf table 10
ip link set vrf0 up
ip tuntap add dev tap0 mode tap
ip link set tap0 master vrf0
ip addr add 172.18.1.2/24 dev tap0
ip link set tap0 up

# 创建vrf1拓扑
ip link add dev vrf1 type vrf table 11
ip link set vrf1 up
ip tuntap add dev tap1 mode tap
ip link set tap1 master vrf1
ip addr add 172.18.2.2/24 dev tap1
ip link set tap1 up

# veth打通vrf
ip link add veth0 type veth peer name veth1
ip link set veth0 master vrf0
ip link set veth1 master vrf1
ip link set veth0 up
ip link set veth1 up
ip route add 172.18.2.0/24 dev veth0 vrf vrf0
ip route add 172.18.1.0/24 dev veth1 vrf vrf1

# 测试互通性
ping 172.18.2.2 -I vrf0

# 清理环境
ip link del dev vrf0
ip link del dev vrf1
ip link del dev tap0
ip link del dev tap1
ip link del dev veth0

