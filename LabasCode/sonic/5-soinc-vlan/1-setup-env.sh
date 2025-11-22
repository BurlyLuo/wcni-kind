cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
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
      - ip r r default via 10.1.5.1

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
    - endpoints: ["sonic1:eth1", "sonic2:eth1"]
    - endpoints: ["sonic1:eth2", "server1:eth1"]
    - endpoints: ["sonic2:eth2", "server2:eth1"]
EOF

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1" "sonic2")
FILES=("sonic.conf" "vtysh.conf")

declare -A config_cmds=(
    ["sonic1"]="sudo config hostname sonic1
sudo config vlan add 10
sudo config interface ip remove Ethernet0 10.0.0.0/31
sudo config interface ip remove Ethernet4 10.0.0.2/31
sudo config vlan member add 10 Ethernet0
sudo config vlan member add -u 10 Ethernet4
sudo config interface ip add Vlan10 10.1.5.1/24
sudo config save -y
sudo chmod +x /usr/local/bin/sonic-cfggen
sudo chmod 666 /etc/sonic/config_db.json
sudo /usr/local/bin/sonic-cfggen -d --print-data > /etc/sonic/config_db.json
sudo config reload -f -y"

    ["sonic2"]="sudo config hostname sonic2
sudo config vlan add 10
sudo config interface ip remove Ethernet0 10.0.0.0/31
sudo config interface ip remove Ethernet4 10.0.0.2/31
sudo config vlan member add 10 Ethernet0
sudo config vlan member add -u 10 Ethernet4
sudo config save -y
sudo chmod +x /usr/local/bin/sonic-cfggen
sudo chmod 666 /etc/sonic/config_db.json
sudo /usr/local/bin/sonic-cfggen -d --print-data > /etc/sonic/config_db.json
sudo config reload -f -y"
)

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Wait $container come into healthy..."
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null | grep "healthy")
        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
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

        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$USER@$container" "
            set -xe
            echo "$node current container list" 
            sudo docker ps -a
            ${config_cmds[$node]}
        " 2>&1; then
                echo "$node config success"
            else
                echo "$node config failed"
        fi
    fi
done

if [[ $? -eq 0 ]]; then
    echo "# docker ps -a"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Names}}" | grep -Ev 'registry|gostwire|edgeshark|openwrt' | awk NF
fi
