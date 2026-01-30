cat <<'EOF'
# https://sonic-net.github.io/SONiC/sonic_latest_images.html
# https://medium.com/sonic-nos/evpn-route-reflector-with-sonic-using-frr-mgmt-framework-db6d12b85ce7
# https://netbergtw.com/top-support/netberg-sonic/vlan-and-vlan-routing/
# https://netbergtw.com/top-support/netberg-sonic/evpn-l2-vxlan/
# https://containerlab.dev/manual/kinds/sonic-vm/
# https://asterfusion.com/blog20240801-evpn-multihoming/?srsltid=AfmBOoo82Lmdfx_zxNymGJCbpUtTsI7CL1rwhWVLKKOaHi2AgG6uXz4v
EOF

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    spine:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest

    leaf1:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest
      stages:
         create:
            wait-for:
              - node: spine
                stage: healthy

    leaf2:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest
      stages:
         create:
            wait-for:
              - node: leaf1
                stage: healthy

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
        - /lib/modules:/lib/modules
      exec:
      - ip a a 100.0.0.2/24 dev net0
      - ip r r default via 100.0.0.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 100.0.0.3/24 dev net0
      - ip r r default via 100.0.0.1

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 200.0.0.2/24 dev net0
      - ip r r default via 200.0.0.1

    server4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 100.0.0.4/24 dev net0
      - ip r r default via 100.0.0.1

  links:
    # sonic-vm container uses the following mapping for its linux interfaces:
    # eth0 - management interface connected to the containerlab management network
    # eth1 - first data (front-panel port) interface that is mapped to Ethernet0 port
    # eth2 - second data interface that is mapped to Ethernet4 port. Any new port will result in a "previous interface + 4" (Ethernet4) mapping.
    # When containerlab launches sonic-vs node, it will assign IPv4/6 address to the eth0 interface. Data interface eth1 mapped to Ethernet0 port.
    # eth1 <> Ethernet0
    # eth2 <> Ethernet1
    # eth3 <> Ethernet2
    # eth4 <> Ethernet3
    # eth5 <> Ethernet4
    
    # spine <> leaf1
    # 11.11.11.2/24 <> 11.11.11.1/24
    - endpoints: ["spine:eth1", "leaf1:eth1"]

    # spine <> leaf2
    # 22.22.22.2/24 <> 22.22.22.1/24
    - endpoints: ["spine:eth3", "leaf2:eth4"]

    # leaf1 <> server1
    # 100.0.0.2/24 vlan 100 vni 100 [gw: 100.0.0.1]
    - endpoints: ["leaf1:eth2", "server1:net0"]

    # leaf1 <> server2
    # 100.0.0.3/24 vlan 100 vni 100 [gw: 100.0.0.1]
    - endpoints: ["leaf1:eth3", "server2:net0"]

    # leaf1 <> server3
    # 200.0.0.2/24 vlan 200 vni 200 [gw: 200.0.0.1]
    - endpoints: ["leaf1:eth4", "server3:net0"]

    # leaf2 <> server4
    # 100.0.0.4/24 vlan 100 vni 100 [gw 100.0.0.1]
    - endpoints: ["leaf2:eth2", "server4:net0"]
EOF

USER="admin"
PASSWD="asteros"
NODES=("spine" "leaf1" "leaf2")

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)

        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
        container_count=${container_count//[[:space:]]/}
        container_count=${container_count:-0}
       
        interface_status=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" 'show int status | awk "/Ethernet0/ {print \$1}"' 2>/dev/null)

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for into healthy... || health_status: $health_status and interface_status: ${interface_status:-n/a} and container_count: $container_count"

        if [ "$health_status" == "healthy"  ] && [ "$container_count" -ge 17 ] && [ "$interface_status" == "Ethernet0" ] 2>/dev/null; then
            sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "sudo rm -rf /etc/shell_mode_cli" 2>/dev/null
            return 0
        fi

        sleep 20
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
            sshpass -p "$PASSWD" ssh-copy-id "$USER@$container" 2>/dev/null
        fi
    fi
done

