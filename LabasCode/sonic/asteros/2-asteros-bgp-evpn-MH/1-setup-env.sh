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
    spine1:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest

    spine2:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest
      stages:
         create:
            wait-for:
              - node: spine1
                stage: healthy

    leaf1:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest
      stages:
         create:
            wait-for:
              - node: spine2
                stage: healthy

    leaf2:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest
      stages:
         create:
            wait-for:
              - node: leaf1
                stage: healthy


    leaf3:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest
      stages:
         create:
            wait-for:
              - node: leaf2
                stage: healthy


    leaf4:
      kind: sonic-vm
      image: 192.168.2.100:5000/asteros_p03:latest
      stages:
         create:
            wait-for:
              - node: leaf3
                stage: healthy

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
        - /lib/modules:/lib/modules
      exec:
      - bash -c "modprobe bonding"
      - ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate fast xmit_hash_policy layer3+4
      - ip l s net0 down
      - ip l s net1 down
      - ip l s net0 master bond0
      - ip l s net1 master bond0
      - ip l s bond0 up
      - ip a a 100.0.0.12/24 dev bond0
      - ip r r default via 100.0.0.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
        - /lib/modules:/lib/modules
      exec:
      - bash -c "modprobe bonding"
      - ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate fast xmit_hash_policy layer3+4
      - ip l s net0 down
      - ip l s net1 down
      - ip l s net0 master bond0
      - ip l s net1 master bond0
      - ip l s bond0 up
      - ip a a 110.0.0.12/24 dev bond0
      - ip r r default via 110.0.0.1


    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      binds:
        - /lib/modules:/lib/modules
      exec:
      - bash -c "modprobe bonding"
      - ip link add bond0 type bond mode 802.3ad miimon 100 lacp_rate fast xmit_hash_policy layer3+4
      - ip l s net0 down
      - ip l s net1 down
      - ip l s net0 master bond0
      - ip l s net1 master bond0
      - ip l s bond0 up
      - ip a a 120.0.0.12/24 dev bond0
      - ip r r default via 120.0.0.1


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
    
    # spine1 <> leaf1
    # 172.16.11.1/24 <> 172.16.11.2/24
    - endpoints: ["spine1:eth2", "leaf1:eth4"]

    # spine1 <> leaf2
    # 172.16.12.1/24 <> 172.15.12.2/24
    - endpoints: ["spine1:eth3", "leaf2:eth4"]

    # spine1 <> leaf3
    # 172.16.13.1/24 <> 172.16.13.2/24
    - endpoints: ["spine1:eth4", "leaf3:eth3"]

    # spine1 <> leaf4
    # 172.16.14.1/24 <> 172.16.14.2/24
    - endpoints: ["spine1:eth5", "leaf4:eth3"]


    # spine2 <> leaf1
    # 172.16.15.1/24 <> 172.16.15.2/24 
    - endpoints: ["spine2:eth2", "leaf1:eth5"]

    # spine2 <> leaf2
    # 172.16.16.1/24 <> 172.16.16.2/24
    - endpoints: ["spine2:eth3", "leaf2:eth5"]

    # spine2 <> leaf3
    # 172.16.17.1/24 <> 172.16.17.2/24
    - endpoints: ["spine2:eth4", "leaf3:eth4"]

    # spine2 <> leaf4
    # 172.16.18.1/24 <> 172.16.18.2/24
    - endpoints: ["spine2:eth5", "leaf4:eth4"]


    # leaf1 <> server1
    # 100.0.0.12/24 vlan5 gw 100.0.0.1/24
    - endpoints: ["leaf1:eth2", "server1:net0"]

    # leaf1 <> server2
    # 110.0.0.12/24 vlan8 gw 110.0.0.1/24
    - endpoints: ["leaf1:eth3", "server2:net0"]

    # leaf2 <> server1
    # 100.0.0.12/24 vlan5 gw 100.0.0.1
    - endpoints: ["leaf2:eth2", "server1:net1"]

    # leaf2 <> server2
    # 110.0.0.12/24 vlan8 gw 110.0.0.1
    - endpoints: ["leaf2:eth3", "server2:net1"]


    # leaf3 <> server3
    # 120.0.0.12/24 vlan5 gw 120.0.0.1/24
    - endpoints: ["leaf3:eth2", "server3:net0"]

    # leaf4 <> server3
    # 120.0.0.12/24 vlan8 gw 120.0.0.1/24
    - endpoints: ["leaf4:eth2", "server3:net1"]
EOF

USER="admin"
PASSWD="asteros"
NODES=("spine1" "spine2" "leaf1" "leaf2" "leaf3" "leaf4")

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)
        sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "sudo rm -rf /etc/shell_mode_cli" 2>/dev/null

        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
        container_count=${container_count//[[:space:]]/}
        container_count=${container_count:-0}
       
        interface_status=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" 'show int status | awk "/Ethernet0/ {print \$1}"' 2>/dev/null)

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for into healthy... || health_status: $health_status and interface_status: ${interface_status:-n/a} and container_count: $container_count"

        if [ "$health_status" == "healthy"  ] && [ "$container_count" -ge 17 ] && [ "$interface_status" == "Ethernet0" ] 2>/dev/null; then
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
        fi
    fi
done

