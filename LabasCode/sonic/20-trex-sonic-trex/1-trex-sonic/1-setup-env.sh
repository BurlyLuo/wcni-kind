cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    client:
      kind: linux
      image: 192.168.2.100:5000/trexcisco/trex:4.1
      exec:
        - ip addr add 10.1.5.10/24 dev eth1
        - ip addr add 10.1.5.11/24 dev eth2
      binds:
        - ./imix.py:/root/imix.py

      ports:
        - 4507:4507
        - 4500:4500
        - 4501:4501
     
      env:
        COLUMNS: "130"
        LINES: "100"
      # port0: 10.1.5.10 eth1
      # port1: 10.1.5.11 eth2
 
      # Run TRex in Stateless mode
      # ./t-rex-64 -i
      
      # stty cols 160 rows 50 
      # Start traffic on port 0 (imix profile)
      # ./trex-console
      # start -f /root/imix.py -m 10kpps --port 0
      # tui

  links:
    # eth1 <> Ethernet0
    # eth2 <> Ethernet4
    # eth3 <> Ethernet8
    # eth4 <> Ethernet12
    - endpoints: ["sonic:eth1", "client:eth1"]
    - endpoints: ["sonic:eth2", "client:eth2"]
EOF

REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic")
FILES=("sonic.conf" "vtysh.conf")

declare -A precfg_vm=(
    ["sonic"]="echo 'export PYTHONWARNINGS=ignore::SyntaxWarning' >> ~/.bashrc
sudo config reload -f -y"
)

declare -A config_cmds=(
    ["sonic"]="sudo config hostname sonic
# config ip address:
sudo config vlan add 5
sudo config vlan member add -u 5 Ethernet0
sudo config vlan member add -u 5 Ethernet4

sudo config save -y
sudo chmod +x /usr/local/bin/sonic-cfggen
sudo chmod 666 /etc/sonic/config_db.json
sudo /usr/local/bin/sonic-cfggen -d --print-data > /etc/sonic/config_db.json"
)

declare -A vtysh_cmds=(
    ["sonic"]="echo 'applying vtysh configuration...'
if timeout 20 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo echo '
!
frr version 8.5.1
frr defaults traditional
hostname sonic
log syslog informational
log facility local4
agentx
no zebra nexthop kernel enable
no service integrated-vtysh-config
!
password zebra
enable password zebra
!
no ip protocol bgp route-map RM_SET_SRC
!
no route-map RM_SET_SRC
!
end
' > /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 20 seconds'
    exit 1
fi"
)

declare -A postcfg_vm=(
    ["sonic"]="vtysh -c 'no ip protocol bgp route-map RM_SET_SRC'
vtysh -c 'no route-map RM_SET_SRC'"
)

wait_for_healthy() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Wait $container come into healthy..."
        health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null | grep "healthy")
        container_count=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "docker ps -aq | wc -l" 2>/dev/null)
        if [ "$health_status" == "healthy"  ] && [ "$container_count" -eq 13 ] 2>/dev/null; then
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
                        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "sudo chmod 666 /etc/sonic/config_db.json && sudo cat $REMOTE_PATH/sonic.conf > /etc/sonic/config_db.json" 2>/dev/null; then
                            echo "init sonic config success"
                        else
                            echo "init sonic config failed"
                        fi
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

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Prepare and config for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            sudo docker ps -a
            ${precfg_vm[$node]}
            ${config_cmds[$node]}
        " 2>&1; then
            echo "$node node prep and config success"
        else
            echo "$node node prep and config failed"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying configuration for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            echo "bypass this case"
            #${vtysh_cmds[$node]}
        " 2>&1; then
            echo "$node node apply configuration success"
        else
            echo "$node node apply configuration failed"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] PostCfg for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            echo "bypass for this case"
            #${postcfg[$node]}
        " 2>&1; then
            echo "$node node postcfg success"
        else
            echo "$node node postcfg failed"
        fi	
    fi
done

if [[ $? -eq 0 ]]; then
    echo "# docker ps -a"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.Status}}\t{{.Names}}" | grep -Ev 'registry|gostwire|edgeshark|openwrt' | awk NF
fi
