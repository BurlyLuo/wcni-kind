cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    sonic3:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    net1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.10/24 dev eth1
        - ip r a 10.1.8.0/24 via 10.1.5.1

    net2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.8.10/24 dev eth1
        - ip r a 10.1.5.0/24 via 10.1.8.1

  links:
    # eth1 <> Ethernet0
    # eth2 <> Ethernet4
    #                  sonic1
    #                   /  \
    #               sonic2 sonic3 
    - endpoints: ["sonic1:eth1", "sonic2:eth2"]
    - endpoints: ["sonic1:eth2", "sonic3:eth2"]
    - endpoints: ["sonic2:eth1", "net1:eth1"]
    - endpoints: ["sonic3:eth1", "net2:eth1"]
EOF

declare -A config_cmds=(
    ["sonic1"]="sudo config hostname soinc1
sudo config reload -f -y
# config ip address and route:
sudo config interface ip add Loopback0 1.1.1.1/32
sudo config interface ip add Ethernet0 10.1.12.1/24
sudo config interface ip add Ethernet4 10.1.13.1/24
sudo config save -y
"

    ["sonic2"]="sudo config hostname soinc2
sudo config reload -f -y
# config ip address and route:
sudo config interface ip add Loopback0 2.2.2.2/32
sudo config interface ip add Ethernet0 10.1.5.1/24
sudo config interface ip add Ethernet4 10.1.12.2/24
sudo config save -y
"

    ["sonic3"]="sudo config hostname soinc3
sudo config reload -f -y
# config ip address and route:
sudo config interface ip add Loopback0 3.3.3.3/32
sudo config interface ip add Ethernet0 10.1.8.1/24
sudo config interface ip add Ethernet4 10.1.13.2/24
sudo config save -y
"
)

declare -A vtysh_cmds=(
    ["sonic1"]="echo 'Applying vtysh configuration...'
if timeout 50 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
frr version 10.4.1
frr defaults traditional
hostname sonic1
log syslog informational
log facility local4
zebra nexthop-group keep 1
fpm address 127.0.0.1
no fpm use-next-hop-groups
agentx
no service integrated-vtysh-config
!
ip prefix-list PL_LoopbackV4 seq 5 permit 1.1.1.1/32
!
password zebra
enable password zebra
!
ip router-id 1.1.1.1
!
router bgp 65001
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.12.2 remote-as 65002
 neighbor 10.1.13.2 remote-as 65003
 !
 address-family ipv4 unicast
  neighbor 10.1.12.2 activate
  neighbor 10.1.13.2 activate  
 exit-address-family
exit
!
ip protocol bgp route-map RM_SET_SRC
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF

cat /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi
"

    ["sonic2"]="echo 'Applying vtysh configuration...'
if timeout 50 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
frr version 10.4.1
frr defaults traditional
hostname sonic2
log syslog informational
log facility local4
zebra nexthop-group keep 1
fpm address 127.0.0.1
no fpm use-next-hop-groups
agentx
no service integrated-vtysh-config
!
ip prefix-list PL_LoopbackV4 seq 5 permit 2.2.2.2/32
!
password zebra
enable password zebra
!
ip router-id 2.2.2.2
!
router bgp 65002
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.12.1 remote-as 65001
 !
 address-family ipv4 unicast
  network 10.1.5.0/24
  neighbor 10.1.12.1 activate  
 exit-address-family
exit
!
ip protocol bgp route-map RM_SET_SRC
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF

cat /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi"

    ["sonic3"]="echo 'Applying vtysh configuration...'
if timeout 50 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
frr version 10.4.1
frr defaults traditional
hostname sonic3
log syslog informational
log facility local4
zebra nexthop-group keep 1
fpm address 127.0.0.1
no fpm use-next-hop-groups
agentx
no service integrated-vtysh-config
!
ip prefix-list PL_LoopbackV4 seq 5 permit 3.3.3.3/32
!
password zebra
enable password zebra
!
ip router-id 3.3.3.3
!
router bgp 65003
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.13.1 remote-as 65001
 !
 address-family ipv4 unicast
  neighbor 10.1.13.1 activate
  network 10.1.8.0/24
 exit-address-family
exit
!
ip protocol bgp route-map RM_SET_SRC
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF

cat /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi"
)


REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1" "sonic2" "sonic3")
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
            sshpass -p "$PASSWD" ssh-copy-id $USER@$container 2>/dev/null
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
            echo "$node Apply vtysh success"
        else
            echo "$node Apply vtysh failed"
        fi
    fi
done
