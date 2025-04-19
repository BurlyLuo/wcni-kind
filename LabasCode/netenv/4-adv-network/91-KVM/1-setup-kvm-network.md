# 1. brctl show
[root@simukvm ~]# brctl show 
bridge name	bridge id		STP enabled	interfaces
brgm		8000.001bcd032389	no		ens2f1
brk8s		8000.2c44fd817713	no		eno4
brmw		8000.001bcd03238a	no		ens2f2
broam		8000.001bcd032388	no		ens2f0
brsm		8000.001bcd03238b	no		ens2f3
brvlan11		8000.001bcd032388	no		ens2f0.11
							vnet10
							vnet17
							vnet27
							vnet31
							vnet36
							vnet40
							vnet46
							vnet51
							vnet6
brvlan1310		8000.001bcd032389	no		ens2f1.1310

# 2. ip -d link show brvlan11
[root@simukvm ~]# ip -d link show brvlan11
628: brvlan11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 00:1b:cd:03:23:88 brd ff:ff:ff:ff:ff:ff promiscuity 0 
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filtering 0 vlan_protocol 802.1Q bridge_id 8000.0:1b:cd:3:23:88 designated_root 8000.0:1b:cd:3:23:88 root_port 0 root_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_change_timer    0.00 gc_timer   41.81 vlan_default_pvid 1 vlan_stats_enabled 0 group_fwd_mask 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast_hash_elasticity 4 mcast_hash_max 512 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000 mcast_startup_query_interval 3125 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_version 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
[root@simukvm ~]# 


# 3. vlan interface as ext-interface
[root@simukvm network-scripts]# cat ifcfg-ens2f0.11 
DEVICE=ens2f0.11
BOOTPROTO=static
ONBOOT=yes
VLAN=yes
BRIDGE=brvlan11
[root@simukvm network-scripts]# cat ifcfg-brvlan11
TYPE=Bridge
BOOTPROTO=static
NAME=brvlan11
DEVICE=brvlan11
ONBOOT=yes
[root@simukvm network-scripts]# 

