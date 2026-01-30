cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
prefix: ""
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03

    h1:
      kind: generic_vm
      image: 192.168.2.100:5000/debian13
      #ip a a 10.1.5.10/24 dev eth1

    h2:
      kind: generic_vm
      image: 192.168.2.100:5000/debian13
      #ip a a 10.1.8.10/24 dev eth1

  links:
    - endpoints: ["sonic1:eth1", "h1:eth1"]
    - endpoints: ["sonic1:eth2", "h2:eth1"]
EOF

USER="admin"
PASSWD="asteros"
SONIC_NODES=("sonic1")
HOST_NODES=("h1" "h2")
IF_NAME=ens2


declare -A sonic_config_cmds=(
    ["sonic1"]="sudo config hostname soinc1
sudo config interface ip add Ethernet0 10.1.5.1/24
sudo config interface startup Ethernet0
sudo config interface mtu Ethernet0 9000
sudo config interface ip add Ethernet1 10.1.8.1/24
sudo config interface startup Ethernet1
sudo config interface mtu Ethernet1 9000
sudo config save -y
"
)


declare -A host_config_cmds=(
    ["h1"]="apt update
apt -y install lrzsz libibverbs1 ibverbs-utils librdmacm1 libibumad3 ibverbs-providers rdma-core net-tools iproute2 perftest iperf3
modprobe rdma_rxe
ip a a 10.1.5.10/24 dev $IF_NAME
ip l s $IF_NAME mtu 9000
ip l s $IF_NAME up
rdma link add rxe1 type rxe netdev $IF_NAME
ibv_devinfo -v -d rxe1
ip r a 10.1.8.0/24 via 10.1.5.1
"

    ["h2"]="apt update
apt -y install lrzsz libibverbs1 ibverbs-utils librdmacm1 libibumad3 ibverbs-providers rdma-core net-tools iproute2 perftest iperf3
modprobe rdma_rxe
IF_NAME=ens2
ip a a 10.1.8.10/24 dev $IF_NAME
ip l s $IF_NAME mtu 9000
ip l s $IF_NAME up
rdma link add rxe1 type rxe netdev $IF_NAME
ibv_devinfo -v -d rxe1
ip r a 10.1.5.0/24 via 10.1.8.1
"
)


wait_for_ready() {
    local container=$1
    local kind=$2
    local max_attempts=20
    local attempt=1
    
    ssh-keygen -f "/root/.ssh/known_hosts" -R "$container" >/dev/null 2>&1

    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)

        if [ "$kind" == "sonic-vm" ]; then
            container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
            container_count=${container_count//[[:space:]]/}
            container_count=${container_count:-0}
           
            interface_status=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" 'show int status | awk "/Ethernet0/ {print \$1}"' 2>/dev/null)

            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for ready... || health_status: $health_status and interface_status: ${interface_status:-n/a} and container_count: $container_count"

            if [ "$health_status" == "healthy" ] && [ "$container_count" -ge 17 ] && [ "$interface_status" == "Ethernet0" ] 2>/dev/null; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] [$kind] Fully ready!"
                return 0
            fi
        else
            if [ "$health_status" == "healthy" ]; then
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] [$kind] Ready!"
                return 0
            fi
        fi

        sleep 20
        ((attempt++))
    done
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] [$kind] Timeout waiting for ready!"
    return 1
}


for node in "${SONIC_NODES[@]}"; do
    if wait_for_ready "$node" sonic-vm; then
        container_id=$(docker ps --filter "name=$node" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$node/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
        fi 
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$node" "
            set -x
            ${sonic_config_cmds[$node]}
        " 2>&1; then
            echo "$host Apply configuration success"
        else
            echo "$host Apply configuration failed"
        fi
        sshpass -p "$PASSWD" ssh-copy-id "$USER@$node"
    fi
done


for host in "${HOST_NODES[@]}"; do
    user=root
    passwd=hive

    if wait_for_ready "$host" generic_vm; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying configuration for $host..."
        if sshpass -p "$passwd" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$user@$host" "
            set -x
            ${host_config_cmds[$host]}
        " 2>&1; then
            echo "$host Apply configuration success"
        else
            echo "$host Apply configuration failed"
        fi
        sshpass -p "$passwd" ssh-copy-id "$user@$host"
    fi
done

# h2 
# ib_send_bw -d rxe1 
# h1
# ib_send_bw -d rxe1 10.1.8.10
