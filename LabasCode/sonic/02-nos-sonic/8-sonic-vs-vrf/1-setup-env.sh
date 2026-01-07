cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest
    
    # Vrf5
    # Vrf5 10.1.5.10 - default Vrf 10.1.5.11
    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.10/24 dev eth1
        - ip r r default via 10.1.5.1
        - ip link set dev eth1 address 52:54:10:01:05:10

    # Vrf8
    # Vrf5 to Vrf8[10.1.5.1 - 10.1.8.1]
    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.8.10/24 dev eth1
        - ip r r default via 10.1.8.1
        - ip link set dev eth1 address 52:54:10:01:08:10

    server3:
      # default VRF:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.11/24 dev eth1
        - ip r r default via 10.1.5.1
        - ip link set dev eth1 address 52:54:10:01:05:11

  links:
    - endpoints: ["sonic1:eth1", "server1:eth1"]
    - endpoints: ["sonic1:eth2", "server2:eth1"]
    - endpoints: ["sonic1:eth3", "server3:eth1"]
EOF

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1")
FILES=("sonic.conf")

declare -A config_cmds=(
    ["sonic1"]="sudo config hostname soinc1
sudo config reload -f -y
# config vrf:
sudo config vrf add Vrfsubnet5
sudo config interface vrf bind Ethernet0 Vrfsubnet5
sudo config vrf add Vrfsubnet8
sudo config interface vrf bind Ethernet4 Vrfsubnet8
# config ip address and route:
sudo config interface ip add Ethernet0 10.1.5.1/24
sudo config interface ip add Ethernet4 10.1.8.1/24
sudo config save -y"
)

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
    fi
done
