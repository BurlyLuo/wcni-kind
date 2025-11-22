cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    vpp1:
      kind: generic_vm
      image: 192.168.2.100:5000/ipng:vpp-proto-bookworm-20250607
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192

    vpp2:
      kind: generic_vm
      image: 192.168.2.100:5000/ipng:vpp-proto-bookworm-20250607
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1
      - ip r a 10.1.8.0/24 via 10.1.5.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev eth1
      - ip r a 10.1.5.0/24 via 10.1.8.1

  links:
    - endpoints: ["vpp1:eth1", "vpp2:eth1"]
    - endpoints: ["vpp1:eth2", "server1:eth1"]
    - endpoints: ["vpp2:eth2", "server2:eth1"]
EOF


REMOTE_PATH="/etc/vpp/"
USER="root"
PASSWD="IPng loves VPP"
CONFIG_BASE_DIR="startupconf"
NODES=("vpp1" "vpp2")
FILES=("bootstrap.vpp" "startup.conf")

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Wait $container come into healthy..."
        if docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null | grep -q "healthy"; then
            return 0
        fi
        sleep 8
        ((attempt++))
    done
    return 1
}

for node in "${NODES[@]}"; do
    container="clab-vs-$node"
    node_config_dir="$CONFIG_BASE_DIR/$node"
 
    if wait_for_healthy "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
        fi
        if [ -d "$node_config_dir" ]; then
            for file in "${FILES[@]}"; do
                config_file="$node_config_dir/$file"
                if [ -f "$config_file" ]; then
                    echo "transfer $config_file to $container..."
                    if sshpass -p "$PASSWD" scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$config_file" "$USER@$container:$REMOTE_PATH" 2>/dev/null; then
                        echo "success transfer $file to $container"
                    else
                        echo "transfer $file to $container failed"
                    fi
                else
                    echo "file $config_file not exist,pass"
                fi
            done
            if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$USER@$container" "systemctl restart vpp" 2>/dev/null; then
                echo "restart vpp success"
            else
                echo "restart vpp failed"
            fi
            if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$USER@$container" "echo 'root:hive'|chpasswd" 2>/dev/null; then
                echo "reset root passwd from  IPng loves VPP  to hive"
            else
                echo "reset root passwd failed"
            fi
        else
            echo "config directory $node_config_dir not exist，pass $container"
        fi
    fi
done

if [[ $? -eq 0 ]]; then
    echo "# docker ps -a"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Names}}" | grep -Ev 'registry|gostwire|edgeshark|openwrt' | awk NF
fi

echo "# Login details:"
cat <<EOF
https://ipng.ch/s/articles/2021/12/23/vpp-linux-cp-virtual-machine-playground/
vpp-proto.qcow2.lrz [Download]
SHA256 'a5fdf157c03f2d202dcccdf6ed97db49c8aa5fdb6b9ca83a1da958a8a24780ab'
Debian Bookworm (12.11) and VPP 25.10-rc0~49-g90d92196
CPU Make sure the (virtualized) CPU supports AVX
RAM The image needs at least 4GB of RAM, and the hypervisor should support hugepages and AVX

Username: ipng with password: ipng loves vpp and is sudo-enabled
Root Password: IPng loves VPP   or  hive

EOF
