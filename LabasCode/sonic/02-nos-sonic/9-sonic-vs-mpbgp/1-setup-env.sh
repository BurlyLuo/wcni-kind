cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    sonic3:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:latest

    net1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.5.10/24 dev eth1
        - ip r a 10.1.8.0/24 via 10.1.5.1

    net2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip a a 10.1.8.10/24 dev eth1
        - ip r a 10.1.5.0/24 via 10.1.8.1

  links:
    # eth1 <> Ethernet0
    # eth2 <> Ethernet4
    #                  sonic1
    #                   /  \
    #               sonic2 sonic3 
    - endpoints: ["sonic1:eth1", "sonic2:eth2"]
    - endpoints: ["sonic1:eth2", "sonic3:eth2"]
    - endpoints: ["sonic2:eth1", "net1:eth1"]
    - endpoints: ["sonic3:eth1", "net2:eth1"]
EOF

declare -A config_cmds=(
    ["sonic1"]="sudo config hostname soinc1
sudo config reload -f -y
# config ip address and route:
sudo config interface ip add Loopback0 1.1.1.1/32
sudo config interface ip add Ethernet0 10.1.12.1/24
sudo config interface ip add Ethernet4 10.1.13.1/24
sudo config save -y
"

    ["sonic2"]="sudo config hostname soinc2
sudo config reload -f -y
# config ip address and route:
sudo config interface ip add Loopback0 2.2.2.2/32
sudo config interface ip add Loopback0 2::2/128
sudo config interface ip add Loopback0 22::22/128
sudo config interface ip add Ethernet0 10.1.5.1/24
sudo config interface ip add Ethernet4 10.1.12.2/24
sudo config save -y
"

    ["sonic3"]="sudo config hostname soinc3
sudo config reload -f -y
# config ip address and route:
sudo config interface ip add Loopback0 3.3.3.3/32
sudo config interface ip add Loopback0 3::3/128
sudo config interface ip add Ethernet0 10.1.8.1/24
sudo config interface ip add Ethernet4 10.1.13.2/24
sudo config save -y
"
)

declare -A vtysh_cmds=(
    ["sonic1"]="echo 'Applying vtysh configuration...'
if timeout 50 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
ip router-id 1.1.1.1
!
router bgp 65001
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.12.2 remote-as 65002
 neighbor 10.1.12.2 capability extended-nexthop
 neighbor 10.1.13.2 remote-as 65003
 neighbor 10.1.13.2 capability extended-nexthop
 !
 address-family ipv4 unicast
  neighbor 10.1.12.2 activate
  neighbor 10.1.13.2 activate
 exit-address-family
 !
 address-family ipv6 unicast
  neighbor 10.1.12.2 activate
  neighbor 10.1.13.2 activate
 exit-address-family
exit
!
ip protocol bgp route-map RM_SET_SRC
!
ipv6 protocol bgp route-map RM_SET_SRC6
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF

cat /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi
"

    ["sonic2"]="echo 'Applying vtysh configuration...'
if timeout 50 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
ip router-id 2.2.2.2
!
router bgp 65002
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.12.1 remote-as 65001
 neighbor 10.1.12.1 capability extended-nexthop
 !
 address-family ipv4 unicast
  network 10.1.5.0/24
  neighbor 10.1.12.1 activate
 exit-address-family
 !
 address-family ipv6 unicast
  network 2::2/128
  neighbor 10.1.12.1 activate
 exit-address-family
exit
!
ip protocol bgp route-map RM_SET_SRC
!
ipv6 protocol bgp route-map RM_SET_SRC6
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF

cat /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi"

    ["sonic3"]="echo 'Applying vtysh configuration...'
if timeout 50 bash -c 'until sudo docker exec bgp vtysh -c \"show version\" &>/dev/null; do sleep 5; done'; then
    echo 'bgp container is ready, applying configuration...'
    sudo cat >/tmp/vtysh.tmp <<'VTYSHEOF'
!
ip router-id 3.3.3.3
!
router bgp 65003
 no bgp ebgp-requires-policy
 no bgp default ipv4-unicast
 bgp bestpath as-path multipath-relax
 no bgp network import-check
 neighbor 10.1.13.1 remote-as 65001
 neighbor 10.1.13.1 capability extended-nexthop
 !
 address-family ipv4 unicast
  network 10.1.8.0/24
  neighbor 10.1.13.1 activate
 exit-address-family
 !
 address-family ipv6 unicast
  network 3::3/128
  neighbor 10.1.13.1 activate
 exit-address-family
exit
!
ip protocol bgp route-map RM_SET_SRC
!
ipv6 protocol bgp route-map RM_SET_SRC6
!
ip nht resolve-via-default
!
ipv6 nht resolve-via-default
!
end
VTYSHEOF

cat /tmp/vtysh.tmp
sudo docker cp /tmp/vtysh.tmp bgp:/root/
sudo docker exec bgp bash -c 'vtysh -f /root/vtysh.tmp'
sudo vtysh -c 'show run'
else
    echo 'ERROR: bgp container did not start within 50 seconds'
    exit 1
fi"
)


REMOTE_PATH="/home/admin/"
USER="admin"
PASSWD="admin"
CONFIG_BASE_DIR="startupconf"
NODES=("sonic1" "sonic2" "sonic3")
FILES=("sonic.conf")

wait_for_ready() {
    local container=$1
    local max_attempts=20
    local attempt=1
    
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
    container="clab-vs-$node"
    node_config_dir="$CONFIG_BASE_DIR/$node"
    
    if wait_for_ready "$container"; then
        container_id=$(docker ps --filter "name=$container" --format "{{.ID}}")
        if [ -n "$container_id" ]; then
            sed -i "/$container/s/$/ $container_id/" /etc/hosts
            echo "append $container id $container_id to local hosts"
            sshpass -p "$PASSWD" ssh-copy-id $USER@$container 2>/dev/null
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
            sleep 2
        " 2>&1; then
            echo "$node Apply configuration success"
        else
            echo "$node Apply configuration failed"
        fi

        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Applying vtysh for $container..."
        if sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USER@$container" "
            set -x
            ${vtysh_cmds[$node]}
        " 2>&1; then
            echo "$node Apply vtysh success"
        else
            echo "$node Apply vtysh failed"
        fi
    fi
done


echo '
# MP-BGP
# sonic2 config:
sonic2(config)# r b 65002
sonic2(config-router)# address-family ipv6 
sonic2(config-router-af)# network 22::22/128 
sonic2(config-router-af)# no network 22::22/128
sonic2(config-router-af)# 

# BGP UPDATE Message:
1.1: Add Route [22::22/128]
1	2025-12-20 19:54:46.097760535	10.1.12.2	10.1.12.1	BGP	168	0xa6c9 (42697)	1	1	103	35754	179	UPDATE Message
2	2025-12-20 19:54:46.143826801	10.1.12.1	10.1.12.2	TCP	66	0x8554 (34132)	1	103	1	179	35754	179 → 35754 [ACK] Seq=1 Ack=103 Win=124 Len=0 TSval=1918080196 TSecr=481829588
#1:
Frame 1: 168 bytes on wire (1344 bits), 168 bytes captured (1344 bits) on interface eth1, id 0
Ethernet II, Src: 22:60:62:d7:bc:00 (22:60:62:d7:bc:00), Dst: 22:3e:1f:2c:4e:51 (22:3e:1f:2c:4e:51)
Internet Protocol Version 4, Src: 10.1.12.2, Dst: 10.1.12.1
Transmission Control Protocol, Src Port: 35754, Dst Port: 179, Seq: 1, Ack: 1, Len: 102
Border Gateway Protocol - UPDATE Message
    Marker: ffffffffffffffffffffffffffffffff
    Length: 102
    Type: UPDATE Message (2)
    Withdrawn Routes Length: 0
    Total Path Attribute Length: 79
    Path attributes
        Path Attribute - MP_REACH_NLRI
            Flags: 0x90, Optional, Extended-Length, Non-transitive, Complete
            Type Code: MP_REACH_NLRI (14)
            Length: 54
            Address family identifier (AFI): IPv6 (2)
            Subsequent address family identifier (SAFI): Unicast (1)
            Next hop: IPv6=fe80::2060:62ff:fed7:bc00 Link-local=fe80::2060:62ff:fed7:bc00
                IPv6 Address: fe80::2060:62ff:fed7:bc00
                Link-local Address: fe80::2060:62ff:fed7:bc00
            Number of Subnetwork points of attachment (SNPA): 0
            Network Layer Reachability Information (NLRI)   # MP_REACH_NLRI: Add 22:22/128 route!
                22::22/128
                    MP Reach NLRI prefix length: 128
                    MP Reach NLRI IPv6 prefix: 22::22
        Path Attribute - ORIGIN: IGP
        Path Attribute - AS_PATH: 65002 
        Path Attribute - MULTI_EXIT_DISC: 0

# 1.2: Del Route [22::22/128]
12	2025-12-20 19:55:27.866406266	10.1.12.2	10.1.12.1	BGP	113	0xa6cd (42701)	122	119	169	35754	179	UPDATE Message
13	2025-12-20 19:55:27.908522869	10.1.12.1	10.1.12.2	TCP	66	0x8558 (34136)	119	169	119	179	35754	179 → 35754 [ACK] Seq=119 Ack=169 Win=124 Len=0 TSval=1918121940 TSecr=481871332
#11:
Frame 12: 113 bytes on wire (904 bits), 113 bytes captured (904 bits) on interface eth1, id 0
Ethernet II, Src: 22:60:62:d7:bc:00 (22:60:62:d7:bc:00), Dst: 22:3e:1f:2c:4e:51 (22:3e:1f:2c:4e:51)
Internet Protocol Version 4, Src: 10.1.12.2, Dst: 10.1.12.1
Transmission Control Protocol, Src Port: 35754, Dst Port: 179, Seq: 122, Ack: 119, Len: 47
Border Gateway Protocol - UPDATE Message
    Marker: ffffffffffffffffffffffffffffffff
    Length: 47
    Type: UPDATE Message (2)
    Withdrawn Routes Length: 0
    Total Path Attribute Length: 24
    Path attributes
        Path Attribute - MP_UNREACH_NLRI
            Flags: 0x90, Optional, Extended-Length, Non-transitive, Complete
            Type Code: MP_UNREACH_NLRI (15)
            Length: 20
            Address family identifier (AFI): IPv6 (2)
            Subsequent address family identifier (SAFI): Unicast (1)
            Withdrawn Routes   # Withdrawn Routes: Del 22:22/128 route!
                22::22/128
                    MP Unreach NLRI prefix length: 128
                    MP Unreach NLRI IPv6 prefix: 22::22

'
