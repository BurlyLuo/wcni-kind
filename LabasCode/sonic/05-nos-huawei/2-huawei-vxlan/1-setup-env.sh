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

    ce2:
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
      startup-config: ./startup-conf/ce2.cfg

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.10/24 dev eth1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.11/24 dev eth1

  links:
    # eth1 <> interface GE1/0/0
    # eth2 <> interface GE1/0/1
    # eth3 <> interface GE1/0/2

    # ce1:eth1 <> server1:eth1
    # access vlan5 <> 10.1.5.10/24
    - endpoints: ["ce1:eth1", "server1:eth1"]

    # ce1:eth2 <> ce2:eth2
    # 1.1.1.11/24 <> 1.1.1.12/24
    - endpoints: ["ce1:eth2", "ce2:eth2"]

    # ce2:eth1 <> ce2:eth1
    # access vlan5 <> 10.1.5.11/24
    - endpoints: ["ce2:eth1", "server2:eth1"]
EOF


USER="admin"
PASSWD="admin"
NODES=("ce1" "ce2")

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
