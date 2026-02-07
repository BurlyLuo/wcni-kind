cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
prefix: ""
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    vm1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1
      - ip r r default via 10.1.5.1
      - ip l s eth1 add 00:00:10:01:05:10

    vm2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev eth1
      - ip r r default via 10.1.5.1
      - ip l s eth1 add 00:00:10:01:05:11

    vm3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.10/24 dev eth1
      - ip r r default via 10.1.8.1
      - ip l s eth1 add 00:00:10:01:08:10

    vm4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.8.11/24 dev eth1
      - ip r r default via 10.1.8.1
      - ip l s eth1 add 00:00:10:01:08:11

    gnmic:
      kind: linux
      image: ghcr.io/openconfig/gnmic:0.43.0
      binds:
        - gnmic/gnmic-config.yaml:/gnmic-config.yaml:ro
      cmd: --config /gnmic-config.yaml --debug --log --log-file /tmp/gnmic.log subscribe

    prometheus:
      kind: linux
      image: prom/prometheus:v3.7.3
      cmd: --config.file=/etc/prometheus/prometheus.yml
      #cmd: --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus/data --web.enable-lifecycle --log.level=info --storage.tsdb.retention.time=30d
      binds:
        #- prometheus/data:/prometheus/data
        - prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      ports:
        - 9090:9090

    grafana:
      kind: linux
      image: grafana/grafana:12.0.2
      binds:
        - grafana/datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yaml:ro
        - grafana/dashboards.yaml:/etc/grafana/provisioning/dashboards/dashboards.yaml:ro
      ports:
        - 3000:3000
      env:
        GF_SECURITY_ADMIN_PASSWORD: "admin"
        GF_USERS_ALLOW_SIGN_UP: "false"

  links:
    # vrnetlab uses the qemu user mode networking to connect the VM's (guest) management interface to the host.
    # https://containerlab.dev/manual/vrnetlab/#management-interface
    # https://wiki.qemu.org/Documentation/Networking#User_Networking_(SLIRP) 

    # sonic-vm container uses the following mapping for its linux interfaces:
    # eth0 - management interface connected to the containerlab management network
    # eth1 - first data (front-panel port) interface that is mapped to Ethernet0 port
    # eth2 - second data interface that is mapped to Ethernet4 port. Any new port will result in a "previous interface + 4" (Ethernet4) mapping.
    # When containerlab launches sonic-vs node, it will assign IPv4/6 address to the eth0 interface. Data interface eth1 mapped to Ethernet0 port.
    
    # sonic1:eth1 <> sonic2:eth1
    # Trunk vlan 5 8
    - endpoints: ["sonic1:eth1", "sonic2:eth1"]

    # sonic1:eth2 <> vm1:eth1
    # Access vlan 5
    - endpoints: ["sonic1:eth2", "vm1:eth1"]

    # sonic2:eth2 <> vm2:eth1
    # Access vlan 8
    - endpoints: ["sonic2:eth2", "vm2:eth1"]

    # sonic1:eth3 <> vm3:eth1
    # Access vlan 5
    - endpoints: ["sonic1:eth3", "vm3:eth1"]

    # sonic2:eth3 <> vm4:eth1
    # Access vlan 8
    - endpoints: ["sonic2:eth3", "vm4:eth1"]
EOF

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1" "sonic2")
FILES=("sonic.conf")

declare -A config_cmds=(
    ["sonic1"]="sudo config hostname soinc1
sudo config reload -f -y

sudo config vlan add 5
sudo config vlan add 8
sudo config vlan member add 5 Ethernet0
sudo config vlan member add 8 Ethernet0
sudo config vlan member add -u 5 Ethernet4
sudo config vlan member add -u 8 Ethernet8

sudo config interface ip add Vlan5 10.1.5.1/24
sudo config interface ip add Vlan8 10.1.8.1/24

sudo config save -y
"
    ["sonic2"]="sudo config hostname soinc2
sudo config reload -f -y

sudo config vlan add 5
sudo config vlan add 8
sudo config vlan member add 5 Ethernet0
sudo config vlan member add 8 Ethernet0
sudo config vlan member add -u 5 Ethernet4
sudo config vlan member add -u 8 Ethernet8
sudo config save -y
"
)

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1" "sonic2")
FILES=("sonic.conf" "vtysh.conf")

wait_for_ready() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    ssh-keygen -f "/root/.ssh/known_hosts" -R "$container" >/dev/null 2>&1    
    while [ $attempt -le $max_attempts ]; do
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)

        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
        container_count=${container_count//[[:space:]]/}
        container_count=${container_count:-0}
       
        interface_status=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" 'show int status | awk "/Ethernet0/ {print \$1}"' 2>/dev/null)

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$container] Waiting for ready... || health_status: $health_status and interface_status: ${interface_status:-n/a}"

        if [ "$health_status" == "healthy"  ] && [ "$interface_status" == "Ethernet0" ] 2>/dev/null; then
            return 0
        fi
        
        sleep 20
        ((attempt++))
    done
    return 1
}

for node in "${NODES[@]}"; do
    container="$node"
    node_config_dir="$CONFIG_BASE_DIR/$node"
    
    if wait_for_ready "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Initing configuration for $container..."
        if [ -d "$node_config_dir" ]; then
            for file in "${FILES[@]}"; do
                config_file="$node_config_dir/$file"
                if [ -f "$config_file" ]; then
                    sshpass -p "$PASSWD" scp -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$config_file" "$USER@$container:$REMOTE_PATH" 2>/dev/null
                    sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "sudo install -m 644 $REMOTE_PATH/sonic.conf /etc/sonic/config_db.json" 2>/dev/null
                fi
            done
        else
            echo "Initing configuration for $container failed"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying configuration for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
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
