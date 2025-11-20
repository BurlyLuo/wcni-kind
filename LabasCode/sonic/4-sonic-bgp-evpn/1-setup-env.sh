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
USERNAME="admin"
PASSWORD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic-bgp" "sonic1" "sonic2")

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Wait $container come into healthy..."
        if docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null | grep -q "healthy"; then
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
        if [ -d "$node_config_dir" ]; then
            for file in sonic.conf vtysh.conf; do
                config_file="$node_config_dir/$file"
                if [ -f "$config_file" ]; then
                    echo "transfer $config_file to $container..."
                    if sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$config_file" "$USERNAME@$container:$REMOTE_PATH" 2>/dev/null; then
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
    fi
done

if [[ $? -eq 0 ]]; then
    echo "# docker ps -a"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Names}}" | grep -Ev 'registry|gostwire|edgeshark|openwrt' | awk NF
fi
