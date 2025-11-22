cat <<'EOF'
# https://sonic-net.github.io/SONiC/sonic_latest_images.html
# https://medium.com/sonic-nos/evpn-route-reflector-with-sonic-using-frr-mgmt-framework-db6d12b85ce7
# https://netbergtw.com/top-support/netberg-sonic/vlan-and-vlan-routing/
# https://netbergtw.com/top-support/netberg-sonic/evpn-l2-vxlan/
# https://containerlab.dev/manual/kinds/sonic-vm/
# TOPO
                     Loopback0 10.1.0.1
                          BGP RR
                      IPv4 L2 EVPN API
                         sonic-bgp
     Ethernet4: 10.0.0.8/31 / \ Ethernet8: 10.0.0.10/31 
                          /     \
 Ethernet4: 10.0.0.9/31 /         \ Ethernet4: 10.0.0.11/31
                  soinc1          soinc2
               BGP Clinet        BGP Clinet
            VTEP: 10.1.0.2      VTEP: 10.1.0.3 
         Loopback0 10.1.0.2    Loopback0 10.1.0.3
              Ethernet0           Ethernet0
               VLAN 10             VLAN 10 
              VNI 1000            VNI 1000
EOF

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic-bgp:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev eth1

  links:
    # sonic-vm container uses the following mapping for its linux interfaces:
    # eth0 - management interface connected to the containerlab management network
    # eth1 - first data (front-panel port) interface that is mapped to Ethernet0 port
    # eth2 - second data interface that is mapped to Ethernet4 port. Any new port will result in a "previous interface + 4" (Ethernet4) mapping.
    # When containerlab launches sonic-vs node, it will assign IPv4/6 address to the eth0 interface. Data interface eth1 mapped to Ethernet0 port.
    - endpoints: ["sonic-bgp:eth2", "sonic1:eth2"]
    - endpoints: ["sonic-bgp:eth3", "sonic2:eth2"]
    - endpoints: ["sonic1:eth1", "server1:eth1"]
    - endpoints: ["sonic2:eth1", "server2:eth1"]
EOF


REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic-bgp" "sonic1" "sonic2")
FILES=("sonic.conf" "vtysh.conf")

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
                    if sshpass -p "$PASSWD" scp -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$config_file" "$USER@$container:$REMOTE_PATH" 2>/dev/null; then
                        echo "success transfer $file to $container"
                    else
                        echo "transfer $file to $container failed"
                    fi
                else
                    echo "file $config_file not exist,pass"
                fi
            done
        else
            echo "config directory $node_config_dir not exist"
        fi
    fi
done

if [[ $? -eq 0 ]]; then
    echo "# docker ps -a"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Names}}" | grep -Ev 'registry|gostwire|edgeshark|openwrt' | awk NF
fi
