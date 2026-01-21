cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: rdma
prefix: ""
topology:
  nodes:
    r1:
      kind: generic_vm
      image: 192.168.2.100:5000/debian13
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192

    r2:
      kind: generic_vm
      image: 192.168.2.100:5000/debian13
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192

  links:
    - endpoints: ["r1:eth1", "r2:eth1"]
    - endpoints: ["r1:eth2", "r2:eth2"]
EOF

USER="root"
PASSWD="hive"
NODES=("r1" "r2")
IF_NAME="ens2"

wait_for_ready() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waitting for ready... (status: $health_status)"
        if [ "$health_status" = "healthy" ]; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] is healthy."
            return 0
        fi
        sleep 15
        ((attempt++))
    done
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] did not become healthy after $max_attempts attempts."
    return 1
}

declare -A config_cmds=(
    ["r1"]="apt update
apt -y install lrzsz libibverbs1 ibverbs-utils librdmacm1 libibumad3 ibverbs-providers rdma-core net-tools iproute2 perftest 
modprobe rdma_rxe
ip a a 10.1.5.10/24 dev $IF_NAME
ip l s $IF_NAME mtu 9000
ip l s $IF_NAME up
rdma link add rxe1 type rxe netdev $IF_NAME
ibv_devinfo -v -d rxe1
"

    ["r2"]="apt update
apt -y install lrzsz libibverbs1 ibverbs-utils librdmacm1 libibumad3 ibverbs-providers rdma-core net-tools iproute2 perftest
modprobe rdma_rxe
ip a a 10.1.5.11/24 dev $IF_NAME
ip l s $IF_NAME mtu 9000
ip l s $IF_NAME up
rdma link add rxe1 type rxe netdev $IF_NAME
ibv_devinfo -v -d rxe1
"
)

for node in "${NODES[@]}"; do
    if wait_for_ready "$node"; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying configuration for $node..."
        ssh-keygen -f "/root/.ssh/known_hosts" -R "$node"
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$node" "
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
