cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: evpn
prefix: ""

topology:
  nodes:
    leaf1:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/bgpd=no/bgpd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/leaf1.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

        # add vtep ip
        - ip addr add 100.64.0.1/32 dev lo
         
        # leaf1 to spine
        - ip addr add 192.168.1.1/24 dev eth1
         
        # add vrf[spec vrf]
        - ip link add red type vrf table 1100
        - ip link set red up

        # For subnet 10.1.5.0/24
        - ip link add br5 type bridge
        - ip link set br5 master red
        - ip link set br5 addr aa:bb:cc:05:01:05
        - ip link add vni5000 type vxlan local 100.64.0.1 dstport 4789 id 5000 nolearning
        - ip link set vni5000 master br5 addrgenmode none
        - ip link set vni5000 type bridge_slave neigh_suppress on learning off
        - ip link set br5 up
        - ip link set vni5000 up
        - ip addr add 10.1.5.254/24 dev br5

        # For subnet 10.1.8.0/24
        - ip link add br8 type bridge
        - ip link set br8 master red
        - ip link set br8 addr aa:bb:cc:08:01:08
        - ip link add vni8000 type vxlan local 100.64.0.1 dstport 4789 id 8000 nolearning
        - ip link set vni8000 master br8 addrgenmode none
        - ip link set vni8000 type bridge_slave neigh_suppress on learning off
        - ip link set br8 up
        - ip link set vni8000 up
        - ip addr add 10.1.8.254/24 dev br8

        # For subnet 10.1.9.0/24 and 10.1.10.0/24
        - ip link add br100 type bridge
        - ip link set br100 master red addrgenmode none
        - ip link set br100 addr aa:bb:cc:09:01:09
        - ip link add vni100 type vxlan local 100.64.0.1 dstport 4789 id 100 nolearning
        - ip link set vni100 master br100 addrgenmode none
        - ip link set vni100 type bridge_slave neigh_suppress on learning off
        - ip link set vni100 up
        - ip link set br100 up
        
        # For leaf1 to vm:10.1.5.x and vm:10.1.8.x and vm:10.1.9.x
        - ip link set eth2 master br5
        - ip link set eth3 master br8
        - ip link set eth4 master red
        - ip addr add 10.1.9.254/24 dev eth4

        - wget -O /tmp/frr_exporter.tar.gz https://github.com/tynany/frr_exporter/releases/download/v1.10.0/frr_exporter-1.10.0.linux-amd64.tar.gz
        - tar -xzf /tmp/frr_exporter.tar.gz -C /tmp/
        - chmod +x /tmp/frr_exporter-1.10.0.linux-amd64/frr_exporter
        - sh -c "/tmp/frr_exporter-1.10.0.linux-amd64/frr_exporter &"


    leaf2:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/bgpd=no/bgpd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/leaf2.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

        # add vtep ip 
        - ip addr add 100.65.0.2/32 dev lo

        # leaf2 to spine
        - ip addr add 192.168.1.3/24 dev eth1

        # add vrf[spec vrf] 
        - ip link add red type vrf table 1100
        - ip link set red up

        # For subnet 10.1.5.0/24 
        - ip link add br5 type bridge
        - ip link set br5 master red
        - ip link set br5 addr aa:bb:cc:05:02:05
        - ip addr add 10.1.5.254/24 dev br5
        - ip link add vni5000 type vxlan local 100.65.0.2 dstport 4789 id 5000 nolearning
        - ip link set vni5000 master br5 addrgenmode none
        - ip link set vni5000 type bridge_slave neigh_suppress on learning off
        - ip link set vni5000 up
        - ip link set br5 up

        # For subnet 10.1.8.0/24
        - ip link add br8 type bridge
        - ip link set br8 master red
        - ip link set br8 addr aa:bb:cc:08:02:08
        - ip addr add 10.1.8.254/24 dev br8
        - ip link add vni8000 type vxlan local 100.65.0.2 dstport 4789 id 8000 nolearning
        - ip link set vni8000 master br8 addrgenmode none
        - ip link set vni8000 type bridge_slave neigh_suppress on learning off
        - ip link set vni8000 up
        - ip link set br8 up

        # For subnet 10.1.9.0/24 and 10.1.10.0/24
        - ip link add br100 type bridge
        - ip link set br100 master red addrgenmode none
        - ip link set br100 addr aa:bb:cc:09:02:09
        - ip link add vni100 type vxlan local 100.65.0.2 dstport 4789 id 100 nolearning
        - ip link set vni100 master br100 addrgenmode none
        - ip link set vni100 type bridge_slave neigh_suppress on learning off
        - ip link set vni100 up
        - ip link set br100 up
        
        - ip link set eth2 master br5
        - ip link set eth3 master br8
        - ip link set eth4 master red
        - ip addr add 10.1.10.254/24 dev eth4

    spine:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/bgpd=no/bgpd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/spine.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf
        # spine to leaf1 and leaf2
        - ip addr add 192.168.1.0/31 dev eth1
        - ip addr add 192.168.1.2/31 dev eth2

    vm1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.5.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:05:10
        - ip r r default via 10.1.5.254
        - bash -c "arping -A -I eth1 -c 50 10.1.5.10 &"

    vm2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.5.11/24 dev eth1
        - ip l s eth1 add 00:00:10:01:05:11
        - ip r r default via 10.1.5.254
        - bash -c "arping -A -I eth1 -c 50 10.1.5.11 &"

    vm3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.8.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:08:10
        - ip r r default via 10.1.8.254
        - bash -c "arping -A -I eth1 -c 50 10.1.8.10 &"

    vm4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.8.11/24 dev eth1
        - ip l s eth1 add 00:00:10:01:08:11
        - ip r r default via 10.1.8.254
        - bash -c "arping -A -I eth1 -c 50 10.1.8.11 &"

    vm5:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.9.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:09:10
        - ip r r default via 10.1.9.254

    vm6:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.10.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:10:10
        - ip r r default via 10.1.10.254

  links:
    # 192.168.1.0/31 <> 192.168.1.1/31
    - endpoints: ["spine:eth1", "leaf1:eth1"]
    # 192.168.1.2/31 <> 192.168.1.3/31
    - endpoints: ["spine:eth2", "leaf2:eth1"]
   
    # 10.1.5.10/24
    - endpoints: ["leaf1:eth2", "vm1:eth1"]
    # 10.1.5.11/24
    - endpoints: ["leaf2:eth2", "vm2:eth1"]
    # 10.1.8.10/24
    - endpoints: ["leaf1:eth3", "vm3:eth1"]
    # 10.1.8.11/24
    - endpoints: ["leaf2:eth3", "vm4:eth1"]

    # 10.1.9.10/24 <> 10.1.10.10/24
    - endpoints: ["leaf1:eth4", "vm5:eth1"]
    - endpoints: ["leaf2:eth4", "vm6:eth1"]
EOF


echo "[$(date '+%Y-%m-%d %H:%M:%S')] BGP EVPN VxLAN PING"
declare -A vm_ips=(
    ["vm1"]="10.1.5.10"
    ["vm2"]="10.1.5.11"  
    ["vm3"]="10.1.8.10"
    ["vm4"]="10.1.8.11"
)
vm_order=("vm1" "vm2" "vm3" "vm4")

for src_vm in "${vm_order[@]}"; do
    src_ip="${vm_ips[$src_vm]}"
    echo -e "\nfrom $src_vm($src_ip) ping vmx:"
    
    for dst_vm in "${vm_order[@]}"; do
        if [ "$src_vm" != "$dst_vm" ]; then
            dst_ip="${vm_ips[$dst_vm]}"
            echo -n "  -> $dst_vm($dst_ip): "
            result=$(docker exec -it "$src_vm" ping -c 1 -W 1 "$dst_ip" 2>/dev/null | grep "ttl=")
            if [ -n "$result" ]; then
                ttl=$(echo "$result" | awk -F 'ttl=' '{print $2}' | awk '{print $1}')
                echo "ok! TTL=$ttl"
            else
                echo "nok"
            fi
        fi
    done
done


cmd_list=(
    "show ip route vrf all bgp"
    "show bgp l2vpn evpn route"
)
for node in leaf1 leaf2; do
    for cmd in "${cmd_list[@]}"; do
        echo -e "\n[$(date '+%Y-%m-%d %H:%M:%S')]**************************$node************************** "
        echo "# docker exec -it $node vtysh -c \"$cmd\""
        docker exec -it $node vtysh -c "$cmd"
    done
done

