cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03

    vyos:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules 
        - ./startup-conf/vyos.cfg:/opt/vyatta/etc/config/config.boot

  links:
    - endpoints: ["sonic:eth1", "vyos:eth1"]
    - endpoints: ["sonic:eth2", "vyos:eth2"]
EOF

USER="admin"
PASSWD="asteros"
NODES=("sonic")

wait_for_ready() {
    local container=$1
    local max_attempts=20
    local attempt=1
    local is_health=false
    
    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)

        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
        container_count=${container_count//[[:space:]]/}
        container_count=${container_count:-0}
       
        interface_status=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" 'show int status | awk "/Ethernet0/ {print \$1}"' 2>/dev/null)

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for ready... || health_status: $health_status and interface_status: ${interface_status:-n/a} and container_count: $container_count"

        if [ "$health_status" == "healthy"  ] && [ "$container_count" -ge 17 ] && [ "$interface_status" == "Ethernet0" ] 2>/dev/null; then
            is_health=true
            return 0
        fi
        
        if is_health=true; then
            sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "sudo rm -rf /etc/shell_mode_cli" 2>/dev/null
        fi

        sleep 20
        ((attempt++))
    done
    return 1
}

for node in "${NODES[@]}"; do
    container="clab-vs-$node"
    if wait_for_ready "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
        fi
    fi
done
