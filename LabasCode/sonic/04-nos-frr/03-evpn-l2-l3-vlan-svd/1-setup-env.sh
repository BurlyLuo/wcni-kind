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
        - modprobe 8021q
        - sysctl -w net.ipv4.ip_forward=1
        - sysctl -w net.ipv6.conf.all.forwarding=1

        # add vtep ip
        - ip addr add 100.64.0.1/32 dev lo
         
        # leaf1 to spine
        - ip addr add 192.168.1.1/24 dev eth1
         
        # add vrf[spec vrf]
        - ip link add red type vrf table 1100
        - ip link set red up

        # create svd vxlan and bridge
        - ip link add br0 type bridge vlan_filtering 1 vlan_default_pvid 0
        - ip link set br0 addrgenmode none
        - ip link set br0 master red
        - ip link set br0 up

        - ip link add vxlan0 type vxlan local 100.64.0.1 dstport 4789 external vnifilter nolearning
        - ip link set vxlan0 addrgenmode none master br0
        - ip link set vxlan0 up

        - bridge link set dev vxlan0 vlan_tunnel on neigh_suppress on learning off

        - ip link set br0 address aa:bb:cc:05:08:01
        - ip link set vxlan0 address aa:bb:cc:05:08:01
 
        # config vlan 5 to vni 5000 mapping
        - bridge vlan add dev br0 vid 5 self
        - bridge vlan add dev vxlan0 vid 5
        - bridge vni add dev vxlan0 vni 5000
        - bridge vlan add dev vxlan0 vid 5 tunnel_info id 5000

        # config vlan 8 to vni 8000 mapping
        - bridge vlan add dev br0 vid 8 self
        - bridge vlan add dev vxlan0 vid 8
        - bridge vni add dev vxlan0 vni 8000
        - bridge vlan add dev vxlan0 vid 8 tunnel_info id 8000

        # config l3 vni 100
        - bridge vlan add dev br0 vid 100 self                
        - bridge vlan add dev vxlan0 vid 100 
        - bridge vni add dev vxlan0 vni 100                 
        - bridge vlan add dev vxlan0 vid 100 tunnel_info id 100

        - ip link add l3vni100 link br0 type vlan id 100
        - ip link set l3vni100 address aa:bb:cc:09:01:09 addrgenmode none
        - ip link set l3vni100 master red
        - ip link set l3vni100 up

        # config leaf1 to host with vlan 5
        - ip link add vlan5 link br0 type vlan id 5
        - ip link set vlan5 up
        - ip a a 10.1.5.254/24 dev vlan5
        - ip link set vlan5 master red
        - ip link set eth2 master br0

        - bridge vlan add dev eth2 vid 5

        # config leaf1 to host with vlan 8
        - ip link add vlan8 link br0 type vlan id 8
        - ip link set vlan8 up
        - ip a a 10.1.8.254/24 dev vlan8
        - ip link set vlan8 master red
        - ip link set eth3 master br0

        - bridge vlan add dev eth3 vid 8


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
        - modprobe 8021q
        - sysctl -w net.ipv4.ip_forward=1
        - sysctl -w net.ipv6.conf.all.forwarding=1

        # add vtep ip 
        - ip addr add 100.65.0.2/32 dev lo

        # leaf2 to spine
        - ip addr add 192.168.1.3/24 dev eth1

        # add vrf[spec vrf] 
        - ip link add red type vrf table 1100
        - ip link set red up

        # create svd vxlan and bridge
        - ip link add br0 type bridge vlan_filtering 1 vlan_default_pvid 0
        - ip link set br0 addrgenmode none
        - ip link set br0 master red
        - ip link set br0 up

        - ip link add vxlan0 type vxlan local 100.65.0.2 dstport 4789 external vnifilter nolearning
        - ip link set vxlan0 addrgenmode none master br0
        - ip link set vxlan0 up

        - bridge link set dev vxlan0 vlan_tunnel on neigh_suppress on learning off

        - ip link set br0 address aa:bb:cc:05:08:02
        - ip link set vxlan0 address aa:bb:cc:05:08:02

 
        # config vlan 5 to vni 5000 mapping
        - bridge vlan add dev br0 vid 5 self
        - bridge vlan add dev vxlan0 vid 5
        - bridge vni add dev vxlan0 vni 5000
        - bridge vlan add dev vxlan0 vid 5 tunnel_info id 5000

        # config vlan 8 to vni 8000 mapping
        - bridge vlan add dev br0 vid 8 self
        - bridge vlan add dev vxlan0 vid 8
        - bridge vni add dev vxlan0 vni 8000
        - bridge vlan add dev vxlan0 vid 8 tunnel_info id 8000

        # config l3 vni 100
        - bridge vlan add dev br0 vid 100 self                
        - bridge vlan add dev vxlan0 vid 100 
        - bridge vni add dev vxlan0 vni 100                 
        - bridge vlan add dev vxlan0 vid 100 tunnel_info id 100

        - ip link add l3vni100 link br0 type vlan id 100
        - ip link set l3vni100 address aa:bb:cc:09:02:09 addrgenmode none
        - ip link set l3vni100 master red
        - ip link set l3vni100 up

        # config leaf2 to host with vlan 5
        - ip link add vlan5 link br0 type vlan id 5
        - ip link set vlan5 up
        - ip a a 10.1.5.254/24 dev vlan5
        - ip link set vlan5 master red
        - ip link set eth2 master br0

        - bridge vlan add dev eth2 vid 5

        # config leaf2 to host with vlan 8
        - ip link add vlan8 link br0 type vlan id 8
        - ip link set vlan8 up
        - ip a a 10.1.8.254/24 dev vlan8
        - ip link set vlan8 master red
        - ip link set eth3 master br0

        - bridge vlan add dev eth3 vid 8


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
        - ip link add link eth1 name eth1.5 type vlan id 5
        - ip l s eth1.5 up
        - ip addr add 10.1.5.10/24 dev eth1.5
        - ip l s eth1.5 add 00:00:10:01:05:10
        - ip r r default via 10.1.5.254

    vm2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip link add link eth1 name eth1.5 type vlan id 5
        - ip l s eth1.5 up
        - ip addr add 10.1.5.11/24 dev eth1.5
        - ip l s eth1.5 add 00:00:10:01:05:11
        - ip r r default via 10.1.5.254

    vm3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip link add link eth1 name eth1.8 type vlan id 8
        - ip l s eth1.8 up
        - ip addr add 10.1.8.10/24 dev eth1.8
        - ip l s eth1.8 add 00:00:10:01:08:10
        - ip r r default via 10.1.8.254

    vm4:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip link add link eth1 name eth1.8 type vlan id 8
        - ip l s eth1.8 up
        - ip addr add 10.1.8.11/24 dev eth1.8
        - ip l s eth1.8 add 00:00:10:01:08:11
        - ip r r default via 10.1.8.254

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
