cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vm
prefix: ""
topology:
  nodes:
    vm1:
      kind: generic_vm
      image: 192.168.2.100:5000/debian13
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192
        USERNAME: root
        PASSWORD: hive

    vm2:
      kind: generic_vm
      image: 192.168.2.100:5000/debian13
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192
        USERNAME: root
        PASSWORD: hive

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev eth1

  links:
    - endpoints: ["vm1:eth1", "vm2:eth1"]
    - endpoints: ["vm1:eth2", "server1:eth1"]
    - endpoints: ["vm2:eth2", "server2:eth1"]
EOF


NODES=("vm1" "vm2")

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Wait [$container] vm come into healthy..."
        if docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null | grep -q "healthy"; then
            return 0
        fi
        sleep 20
        ((attempt++))
    done
    return 1
}

for node in "${NODES[@]}"; do
    container="$node"
    
    if wait_for_healthy "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
            ssh-keygen -f "/root/.ssh/known_hosts" -R "$container" >/dev/null 2>&1
        fi
    fi
done
