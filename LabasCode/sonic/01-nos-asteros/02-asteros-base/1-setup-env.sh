cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
prefix: ""
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03

    h1:
      kind: generic_vm
      image: 192.168.2.100:5000/ubuntu:2204
      #ip a a 10.1.5.10/24 dev eth1

    h2:
      kind: generic_vm
      image: 192.168.2.100:5000/ubuntu:2204
      #ip a a 10.1.9.10/24 dev eth1

    h3:
      kind: generic_vm
      image: 192.168.2.100:5000/ubuntu:2204
      #ip a a 10.1.8.10/24 dev eth1

  links:
    - endpoints: ["sonic1:eth1", "sonic2:eth1"]
    - endpoints: ["sonic1:eth2", "h1:eth1"]
    - endpoints: ["sonic1:eth3", "h2:eth1"]
    - endpoints: ["sonic2:eth2", "h3:eth1"]
EOF

USER="admin"
PASSWD="asteros"
NODES=("sonic1" "sonic2")

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

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for ready... || health_status: $health_status and interface_status: ${interface_status:-n/a} and container_count: $container_count"

        if [ "$health_status" == "healthy"  ] && [ "$container_count" -ge 17 ] && [ "$interface_status" == "Ethernet0" ] 2>/dev/null; then
            return 0
        fi

        sleep 20
        ((attempt++))
    done
    return 1
}

for node in "${NODES[@]}"; do
    container="$node"
    if wait_for_ready "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
        fi
    fi
done
