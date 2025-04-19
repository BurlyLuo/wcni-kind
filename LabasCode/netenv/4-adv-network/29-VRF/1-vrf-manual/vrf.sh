#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Usage: ./vrf.sh create"
    echo "Usage: ./vrf.sh destroy"
    exit
fi

echo "README-2024/05/25
# https://docs.kernel.org/networking/vrf.html
# TOPO:
# 192.168.2.99：
#        tap0---vrf0---veth0=======veth1---vrf1---tap1
#
#        tap0: 172.18.1.2/24
#        tap1: 172.18.2.2/24
"
vrf_create() {
    set -x
    # 1. Create VRF0 instance
    echo "# 1. Create VRF0 instance"
    ip link add dev vrf0 type vrf table 10
    ip link set vrf0 up
    ip tuntap add dev tap0 mode tap
    ip link set tap0 master vrf0
    ip addr add 172.18.1.2/24 dev tap0
    ip link set tap0 up
    
    # 2. Create VRF1 instance
    echo "# 2. Create VRF1 instance"
    ip link add dev vrf1 type vrf table 11
    ip link set vrf1 up
    ip tuntap add dev tap1 mode tap
    ip link set tap1 master vrf1
    ip addr add 172.18.2.2/24 dev tap1
    ip link set tap1 up
    
    # 3. veth to VRF
    echo "# 3. veth to VRF"
    ip link add veth0 type veth peer name veth1
    ip link set veth0 master vrf0
    ip link set veth1 master vrf1
    ip link set veth0 up
    ip link set veth1 up
    ip route add 172.18.2.0/24 dev veth0 vrf vrf0
    ip route add 172.18.1.0/24 dev veth1 vrf vrf1
    
    # 4. ping test
    echo "# 4. ping test"
    ping 172.18.2.2 -I vrf0 -c 5
    set +x
}

vrf_destroy() {
    set -x
    # 5. cleanup
    ip link del dev vrf0
    ip link del dev vrf1
    ip link del dev tap0
    ip link del dev tap1
    ip link del dev veth0
    set +x
}

vrf_init() {
    if [[ $1 == "create" ]]; then
        vrf_destroy;vrf_create
    elif [[ $1 == "destroy" ]]; then
        vrf_destroy
    else 
        echo "******************************************************"
        echo "\$1 parameter error! Should be from [create or destroy]"
        echo "******************************************************"
    fi
}

vrf_init $1

