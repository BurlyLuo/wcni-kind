cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    ce1:
      kind: huawei_vrp
      image: 192.168.2.100:5000/huawei_vrp:ce12800-8.180
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 6144
      healthcheck:
        test:
          - CMD
          - /healthcheck.py
        retries: 15
      startup-config: ./startup-conf/ce1.cfg

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.11/24 dev eth1
        - ip a a 10.1.8.11/24 dev eth2

  links:
    # ce1:eth1 <> server1:eth1
    # 10.1.5.10/24 <> 10.1.5.11/24
    - endpoints: ["ce1:eth1", "server1:eth1"]
    # sonic1:eth2 <> server1:eth2
    # 10.1.8.10/24 <> 10.1.8.11/24
    - endpoints: ["ce1:eth2", "server1:eth2"]
EOF


USER="admin"
PASSWD="admin"
NODES=("ce1")

wait_for_ready() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for ready... || health_status: $health_status"

        if [ "$health_status" == "healthy"  ] 2>/dev/null; then
            return 0
        fi
        
        sleep 30
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
