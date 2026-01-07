cat <<EOF
# https://sonic-net.github.io/SONiC/sonic_latest_images.html
# https://medium.com/sonic-nos/evpn-route-reflector-with-sonic-using-frr-mgmt-framework-db6d12b85ce7
# https://netbergtw.com/top-support/netberg-sonic/vlan-and-vlan-routing/
# https://netbergtw.com/top-support/netberg-sonic/evpn-l2-vxlan/
# https://containerlab.dev/manual/kinds/sonic-vm/
EOF

# https://www.dell.com/support/manuals/zh-cn/smartfabric-os10-emp-partner/vxlan-evpn-10-5-2_ug/example-vxlan-bgp-evpn-%E2%80%94-multiple-as-topology?guid=guid-2f1df7c3-99bf-4f7d-bc2e-a635373feefa&lang=en-us
cat <<EOF>./clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    spine1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    spine2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    leaf1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    leaf2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1
      - ip link set dev eth1 address 52:54:10:01:05:10

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev eth1
      - ip link set dev eth1 address 52:54:10:01:08:10

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev eth1
      - ip link set dev eth1 address 52:54:10:01:05:11

    server4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.11/24 dev eth1
      - ip link set dev eth1 address 52:54:10:01:08:11

    server1-vlan5:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.12/24 dev eth1
      - ip link set dev eth1 address 52:54:10:01:05:12

  links:
    # sonic-vm container uses the following mapping for its linux interfaces:
    # eth0 - management interface connected to the containerlab management network
    # eth1 - first data (front-panel port) interface that is mapped to Ethernet0 port
    # eth2 - second data interface that is mapped to Ethernet4 port. Any new port will result in a "previous interface + 4" (Ethernet4) mapping.
    # When containerlab launches sonic-vs node, it will assign IPv4/6 address to the eth0 interface. Data interface eth1 mapped to Ethernet0 port.
    # eth1 <> Ethernet0
    # eth2 <> Ethernet4
    # eth3 <> Ethernet8
    # eth4 <> Ethernet12
    # eth5 <> Ethernet16
    
    # spine1 <> leaf1
    # 10.1.10.2/24 <> 10.1.10.1/24
    - endpoints: ["spine1:eth1", "leaf1:eth1"]

    # spine1 <> leaf2
    # 10.1.34.2/24 <> 10.1.34.1/24
    - endpoints: ["spine1:eth2", "leaf2:eth1"]

    # spine2 <> leaf1
    # 10.1.12.2/24 <> 10.1.12.1/24 
    - endpoints: ["spine2:eth1", "leaf1:eth2"]

    # spine2 <> leaf2
    # 10.1.11.2/24 <> 10.1.11.1/24
    - endpoints: ["spine2:eth2", "leaf2:eth2"]

    # leaf1 <> server1
    # 10.1.5.10/24 vlan5
    - endpoints: ["leaf1:eth3", "server1:eth1"]

    # leaf1 <> server2
    # 10.1.8.10/23 vlan8
    - endpoints: ["leaf1:eth4", "server2:eth1"]

    # leaf1 <> server1-vlan5
    # 10.1.5.12/24
    - endpoints: ["leaf1:eth5", "server1-vlan5:eth1"]

    # leaf2 <> server3
    # 10.1.5.11 vlan5
    - endpoints: ["leaf2:eth3", "server3:eth1"]

    # leaf2 <> server4
    # 10.1.8.11 vlan8
    - endpoints: ["leaf2:eth4", "server4:eth1"]
EOF


declare -A config_cmds=(
    ["spine1"]="sudo config reload -f -y
sudo config hostname spine1
# config ip address:
sudo config loopback add Loopback0
sudo config interface ip add Loopback0 1.1.1.1/32
sudo config interface ip add Ethernet0 10.1.10.2/24
sudo config interface ip add Ethernet4 10.1.34.2/24
sudo config save -y"

    ["spine2"]="sudo config reload -f -y
sudo config hostname spine2
# config ip address:
sudo config loopback add Loopback0
sudo config interface ip add Loopback0 2.2.2.2/32
sudo config interface ip add Ethernet0 10.1.12.2/24
sudo config interface ip add Ethernet4 10.1.11.2/24
sudo config save -y
"

    ["leaf1"]="sudo config reload -f -y
sudo config hostname leaf1
# config sonic vlan:
sudo config vlan add 5
sudo config vlan member add -u 5 Ethernet8
sudo config vlan member add -u 5 Ethernet16
sudo config vlan add 8
sudo config vlan member add -u 8 Ethernet12
# config ip address:
sudo config loopback add Loopback0
sudo config interface ip add Loopback0 5.5.5.5/32
sudo config interface ip add Ethernet0 10.1.10.1/24
sudo config interface ip add Ethernet4 10.1.12.1/24
# config vxlan:
sudo config vxlan add vtep_wluo 5.5.5.5
sudo config vxlan evpn_nvo add nvo_wluo vtep_wluo
sudo config vxlan map add vtep_wluo 5 5000
sudo config vxlan map add vtep_wluo 8 8000
sudo config save -y
"

    ["leaf2"]="sudo config reload -f -y
sudo config hostname leaf2
# config sonic vlan:
sudo config vlan add 5
sudo config vlan member add -u 5 Ethernet8
sudo config vlan add 8
sudo config vlan member add -u 8 Ethernet12
# config ip address:
sudo config loopback add Loopback0
sudo config interface ip add Loopback0 8.8.8.8/32
sudo config interface ip add Ethernet0 10.1.34.1/24
sudo config interface ip add Ethernet4 10.1.11.1/24
# config vxlan:
sudo config vxlan add vtep_wluo 8.8.8.8
sudo config vxlan evpn_nvo add nvo_wluo vtep_wluo
sudo config vxlan map add vtep_wluo 5 5000
sudo config vxlan map add vtep_wluo 8 8000
sudo config save -y
"
)

declare -A vtysh_cmds=(
    ["spine1"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo echo '
!
hostname spine1
!
router bgp 500
 bgp router-id 1.1.1.1
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.10.1 remote-as 65005
 neighbor 10.1.34.1 remote-as 65008
 !
 address-family ipv4 unicast
  redistribute connected
  network 1.1.1.1/32
  neighbor 10.1.10.1 activate
  neighbor 10.1.34.1 activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor 10.1.10.1 activate
  neighbor 10.1.34.1 activate
  advertise-all-vni
 exit-address-family
exit
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
no ip protocol bgp route-map RM_SET_SRC
!
no route-map RM_SET_SRC
!
end
' > /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 20 seconds'
    exit 1
fi"

    ["spine2"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo echo '
!
hostname spine2
!
router bgp 800
 bgp router-id 2.2.2.2
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.12.1 remote-as 65005
 neighbor 10.1.11.1 remote-as 65008
 !
 address-family ipv4 unicast
  redistribute connected
  network 2.2.2.2/32
  neighbor 10.1.12.1 activate
  neighbor 10.1.11.1 activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor 10.1.12.1 activate
  neighbor 10.1.11.1 activate
  advertise-all-vni
 exit-address-family
exit
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
no ip protocol bgp route-map RM_SET_SRC
!
no route-map RM_SET_SRC
!
end
' > /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 20 seconds'
    exit 1
fi"

    ["leaf1"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo echo '
!
hostname leaf1
!
router bgp 65005
 bgp router-id 5.5.5.5
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.10.2 remote-as 500
 neighbor 10.1.12.2 remote-as 800
 !
 address-family ipv4 unicast
  redistribute connected
  network 5.5.5.5/32
  neighbor 10.1.10.2 activate
  neighbor 10.1.12.2 activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor 10.1.10.2 activate
  neighbor 10.1.12.2 activate
  advertise-all-vni
 exit-address-family
exit
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
no ip protocol bgp route-map RM_SET_SRC
!
no route-map RM_SET_SRC
!
end
' >/tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 20 seconds'
    exit 1
fi"

    ["leaf2"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo echo '
!
hostname leaf2
!
router bgp 65008
 bgp router-id 8.8.8.8
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.34.2 remote-as 500
 neighbor 10.1.11.2 remote-as 800
 !
 address-family ipv4 unicast
  redistribute connected
  network 8.8.8.8/32
  neighbor 10.1.34.2 activate
  neighbor 10.1.11.2 activate
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor 10.1.34.2 activate
  neighbor 10.1.11.2 activate
  advertise-all-vni
 exit-address-family
exit
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
no ip protocol bgp route-map RM_SET_SRC
!
no route-map RM_SET_SRC
!
end
' >/tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 20 seconds'
    exit 1
fi"
)

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("spine1" "spine2" "leaf1" "leaf2")
FILES=("sonic.conf")

wait_for_ready() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)

        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
        container_count=${container_count//[[:space:]]/}
        container_count=${container_count:-0}
       
        interface_status=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" 'show int status | awk "/Ethernet0/ {print \$1}"' 2>/dev/null)

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for ready... || health_status: $health_status and interface_status: ${interface_status:-n/a}"

        if [ "$health_status" == "healthy"  ] && [ "$interface_status" == "Ethernet0" ] 2>/dev/null; then
            return 0
        fi
        
        sleep 20
        ((attempt++))
    done
    return 1
}

for node in "${NODES[@]}"; do
    container="clab-vs-$node"
    node_config_dir="$CONFIG_BASE_DIR/$node"
    
    if wait_for_ready "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
            sshpass -p "$PASSWD" ssh-copy-id "$USER@$container" 2>/dev/null
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Initing configuration for $container..."
        if [ -d "$node_config_dir" ]; then
            for file in "${FILES[@]}"; do
                config_file="$node_config_dir/$file"
                if [ -f "$config_file" ]; then
                    sshpass -p "$PASSWD" scp -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$config_file" "$USER@$container:$REMOTE_PATH" 2>/dev/null
                    sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "sudo install -m 644 $REMOTE_PATH/sonic.conf /etc/sonic/config_db.json" 2>/dev/null
                fi
            done
        else
            echo "Initing configuration for $container failed"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying configuration for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            ${config_cmds[$node]}
            sleep 2
        " 2>&1; then
            echo "$node Apply configuration success"
        else
            echo "$node Apply configuration failed"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying vtysh for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            ${vtysh_cmds[$node]}
        " 2>&1; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $node Apply vtysh success"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $node Apply vtysh failed"
        fi
    fi
done
