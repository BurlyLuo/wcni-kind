cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: evpn
prefix: ""
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/stordis:4.x
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/stordis:4.x
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192


    vm1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1
      - ip r r default via 10.1.5.1
      - ip l s eth1 add 00:00:10:01:05:10

    vm2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev eth1
      - ip r r default via 10.1.8.1
      - ip l s eth1 add 00:00:10:01:08:10

    vm3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev eth1
      - ip r r default via 10.1.5.1
      - ip l s eth1 add 00:00:10:01:05:11

    vm4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.11/24 dev eth1
      - ip r r default via 10.1.8.1
      - ip l s eth1 add 00:00:10:01:08:11

  links:
    # eth1 <> Ethernet0
    # eth2 <> Ethernet1
    # eth3 <> Ethernet2

    # sonic1:eth1 <> sonic2:eth1
    - endpoints: ["sonic1:eth1", "sonic2:eth1"]

    # sonic1:eth2 <> vm1:eth1
    # Access vlan 5
    - endpoints: ["sonic1:eth2", "vm1:eth1"]

    # sonic2:eth2 <> vm2:eth1
    # Access vlan 8
    - endpoints: ["sonic2:eth2", "vm2:eth1"]

    # sonic1:eth3 <> vm3:eth1
    # Access vlan 5
    - endpoints: ["sonic1:eth3", "vm3:eth1"]

    # sonic2:eth3 <> vm4:eth1
    # Access vlan 8
    - endpoints: ["sonic2:eth3", "vm4:eth1"]
EOF

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1" "sonic2")

declare -A config_cmds=(
    ["sonic1"]="sudo config hostname sonic1
# config ip address and route:
sudo config ztp disable -y
sudo config save -y"

    ["sonic2"]="sudo config hostname sonic2
# config ip address and route:
sudo config ztp disable -y
sudo config save -y"
)

wait_for_ready() {
    local container=$1
    local max_attempts=20
    local attempt=1
    ssh-keygen -f "/root/.ssh/known_hosts" -R "$container" >/dev/null 2>&1
    
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
    container="$node"
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
        sshpass -p "$PASSWD" ssh-copy-id "$USER@$node"
    fi
done
