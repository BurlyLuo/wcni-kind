cat <<'EOF'
# https://sonic-net.github.io/SONiC/sonic_latest_images.html
# https://medium.com/sonic-nos/evpn-route-reflector-with-sonic-using-frr-mgmt-framework-db6d12b85ce7
# https://netbergtw.com/top-support/netberg-sonic/vlan-and-vlan-routing/
# https://netbergtw.com/top-support/netberg-sonic/evpn-l2-vxlan/
# https://containerlab.dev/manual/kinds/sonic-vm/
# TOPO
                     Loopback0 10.1.0.1
                          BGP RR
                      IPv4 L2 EVPN API
                         sonic-bgp
     Ethernet4: 10.0.0.8/31 / \ Ethernet8: 10.0.0.10/31 
                          /     \
 Ethernet4: 10.0.0.9/31 /         \ Ethernet4: 10.0.0.11/31
                  soinc1          soinc2
               BGP Clinet        BGP Clinet
            VTEP: 10.1.0.2      VTEP: 10.1.0.3 
         Loopback0 10.1.0.2    Loopback0 10.1.0.3
              Ethernet0           Ethernet0
               VLAN 10             VLAN 10 
              VNI 1000            VNI 1000
EOF

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic-bgp:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev eth1

  links:
    # sonic-vm container uses the following mapping for its linux interfaces:
    # eth0 - management interface connected to the containerlab management network
    # eth1 - first data (front-panel port) interface that is mapped to Ethernet0 port
    # eth2 - second data interface that is mapped to Ethernet4 port. Any new port will result in a "previous interface + 4" (Ethernet4) mapping.
    # When containerlab launches sonic-vs node, it will assign IPv4/6 address to the eth0 interface. Data interface eth1 mapped to Ethernet0 port.

    - endpoints: ["sonic-bgp:eth2", "sonic1:eth2"]
    - endpoints: ["sonic-bgp:eth3", "sonic2:eth2"]
    - endpoints: ["sonic1:eth1", "server1:eth1"]
    - endpoints: ["sonic2:eth1", "server2:eth1"]
EOF


REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic-bgp" "sonic1" "sonic2")
FILES=("sonic.conf" "vtysh.conf")

declare -A prep_vm=(
    ["sonic-bgp"]="echo 'export PYTHONWARNINGS=ignore::SyntaxWarning' >> ~/.bashrc"
	
    ["sonic1"]="echo 'export PYTHONWARNINGS=ignore::SyntaxWarning' >> ~/.bashrc"

    ["sonic2"]="echo 'export PYTHONWARNINGS=ignore::SyntaxWarning' >> ~/.bashrc"
)

declare -A config_cmds=(
    ["sonic-bgp"]="sudo config reload -f -y
sudo config hostname soinc-bgp
# config sonic ip address:
sudo config loopback add Loopback0
sudo config interface ip add Loopback0 10.1.0.1/32
sudo config interface ip add Ethernet4 10.0.0.8/31
sudo config interface ip add Ethernet8 10.0.0.10/31

sudo config save -y
sudo chmod +x /usr/local/bin/sonic-cfggen
sudo chmod 666 /etc/sonic/config_db.json
sudo /usr/local/bin/sonic-cfggen -d --print-data > /etc/sonic/config_db.json"

    ["sonic1"]="sudo config reload -f -y
sudo config hostname soinc1
# config sonic vlan:
sudo config vlan add 10
sudo config vlan member add -u 10 Ethernet0
# config ip address:
sudo config loopback add Loopback0
sudo config interface ip add Loopback0 10.1.0.2/32
sudo config interface ip add Ethernet4 10.0.0.9/31
# config vxlan:
sudo config vxlan add vtep 10.1.0.2
sudo config vxlan evpn_nvo add nvo vtep
sudo config vxlan map add vtep 10 1000

sudo config save -y
sudo chmod +x /usr/local/bin/sonic-cfggen
sudo chmod 666 /etc/sonic/config_db.json
sudo /usr/local/bin/sonic-cfggen -d --print-data > /etc/sonic/config_db.json"

    ["sonic2"]="sudo config reload -f -y
sudo config hostname soinc2
# config sonic vlan:
sudo config vlan add 10
sudo config vlan member add -u 10 Ethernet0
# config ip address:
sudo config loopback add Loopback0
sudo config interface ip add Loopback0 10.1.0.3/32
sudo config interface ip add Ethernet4 10.0.0.11/31
# config vxlan:
sudo config vxlan add vtep 10.1.0.3
sudo config vxlan evpn_nvo add nvo vtep
sudo config vxlan map add vtep 10 1000

sudo config save -y
sudo chmod +x /usr/local/bin/sonic-cfggen
sudo chmod 666 /etc/sonic/config_db.json
sudo /usr/local/bin/sonic-cfggen -d --print-data > /etc/sonic/config_db.json"
)

declare -A vtysh_cmds=(
    ["sonic-bgp"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
frr version 8.5.1
frr defaults traditional
hostname sonic-bgp
log syslog informational
log facility local4
agentx
no zebra nexthop kernel enable
no service integrated-vtysh-config
!
password zebra
enable password zebra
!
router bgp 65000
 bgp router-id 10.1.0.1
 no bgp default ipv4-unicast
 neighbor 10.0.0.9 remote-as 65000
 neighbor 10.0.0.11 remote-as 65000
 !
 address-family ipv4 unicast
  network 10.1.0.1/32
  redistribute connected
  neighbor 10.0.0.9 activate
  neighbor 10.0.0.9 route-reflector-client
  neighbor 10.0.0.9 next-hop-self force
  neighbor 10.0.0.11 activate
  neighbor 10.0.0.11 route-reflector-client
  neighbor 10.0.0.11 next-hop-self force
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor 10.0.0.9 activate
  neighbor 10.0.0.9 route-reflector-client
  neighbor 10.0.0.11 activate
  neighbor 10.0.0.11 route-reflector-client
  advertise-all-vni
 exit-address-family
exit
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi"

    ["sonic1"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
frr version 8.5.1
frr defaults traditional
hostname sonic1
log syslog informational
log facility local4
no zebra nexthop kernel enable
agentx
no service integrated-vtysh-config
!
password zebra
enable password zebra
!
router bgp 65000
 bgp router-id 10.1.0.2
 neighbor 10.0.0.8 remote-as 65000
 !
 address-family ipv4 unicast
  network 10.1.0.2/32
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor 10.0.0.8 activate
  advertise-all-vni
 exit-address-family
exit
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi"

    ["sonic2"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
frr version 8.5.1
frr defaults traditional
hostname sonic2
log syslog informational
log facility local4
no zebra nexthop kernel enable
agentx
no service integrated-vtysh-config
!
password zebra
enable password zebra
!
router bgp 65000
 bgp router-id 10.1.0.3
 neighbor 10.0.0.10 remote-as 65000
 !
 address-family ipv4 unicast
  network 10.1.0.3/32
 exit-address-family
 !
 address-family l2vpn evpn
  neighbor 10.0.0.10 activate
  advertise-all-vni
 exit-address-family
exit
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi"
)

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Wait $container come into healthy..."
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null | grep "healthy")
        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
        if [ "$health_status" == "healthy"  ] && [ "$container_count" -eq 13 ] 2>/dev/null; then
            return 0
        fi
        sleep 8
        ((attempt++))
    done
    return 1
}

for node in "${NODES[@]}"; do
    container="clab-vs-$node"
    node_config_dir="$CONFIG_BASE_DIR/$node"
    
    if wait_for_healthy "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
        fi
        if [ -d "$node_config_dir" ]; then
            for file in "${FILES[@]}"; do
                config_file="$node_config_dir/$file"
                if [ -f "$config_file" ]; then
                    echo "transfer $config_file to $container..."
                    if sshpass -p "$PASSWD" scp -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$config_file" "$USER@$container:$REMOTE_PATH" 2>/dev/null; then
                        echo "success transfer $file to $container"
                        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "sudo chmod 666 /etc/sonic/config_db.json && sudo cat $REMOTE_PATH/sonic.conf > /etc/sonic/config_db.json" 2>/dev/null; then
                            echo "init sonic config success"
                        else
                            echo "init sonic config failed"
                        fi
                    else
                        echo "transfer $file to $container failed"
                    fi
                else
                    echo "file $config_file not exist,pass"
                fi
            done
        else
            echo "config directory $node_config_dir not exist"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Prepare and config for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            ${prep_vm[$node]}
            sudo docker ps -a
            ${config_cmds[$node]}
        " 2>&1; then
            echo "$node node prep and config success"
        else
            echo "$node node prep and config failed"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying configuration for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            ${vtysh_cmds[$node]}
        " 2>&1; then
            echo "$node node apply configuration success"
        else
            echo "$node node apply configuration failed"
        fi		
    fi
done

if [[ $? -eq 0 ]]; then
    echo "# docker ps -a"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Names}}" | grep -Ev 'registry|gostwire|edgeshark|openwrt' | awk NF
fi

