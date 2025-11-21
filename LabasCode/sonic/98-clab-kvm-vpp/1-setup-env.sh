cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    vm1:
      kind: generic_vm
      image: 192.168.2.100:5000/ipng:vpp-proto-bookworm-20250607
      env:
        QEMU_SMP: 6
        QEMU_MEMORY: 8192

    vm2:
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
    
    if wait_for_healthy "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
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
Root Password: IPng loves VPP

EOF
