cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.11/24 dev eth1
        - ip a a 10.1.8.11/24 dev eth2

  links:
    # sonic1:eth1 <> server1:eth1
    # 10.1.5.10/24 <> 10.1.5.11/24
    - endpoints: ["sonic1:eth1", "server1:eth1"]
    # sonic1:eth2 <> server1:eth2
    # 10.1.8.10/24 <> 10.1.8.11/24
    - endpoints: ["sonic1:eth2", "server1:eth2"]
EOF

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1")

declare -A config_cmds=(
    ["sonic1"]="sudo config hostname soinc1
# config ip address and route:
sudo config ztp disable -y
sudo config interface ip add Ethernet0 10.1.5.10/24
sudo config interface ip add Ethernet1 10.1.8.10/24
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
