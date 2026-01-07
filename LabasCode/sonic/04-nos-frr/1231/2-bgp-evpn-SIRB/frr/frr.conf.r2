frr defaults datacenter
log file /var/log/frr/bgpd.log
!
router bgp 65000
 bgp router-id 100.64.0.2
 no bgp default ipv4-unicast
 neighbor SPINE peer-group
 neighbor SPINE remote-as internal
 neighbor 192.168.100.1 peer-group SPINE
 !
 address-family l2vpn evpn
  neighbor SPINE activate
  neighbor SPINE soft-reconfiguration inbound
  advertise-all-vni
  advertise-svi-ip
  advertise ipv4 unicast  # ★★★ 关键: 启用Type 5路由 ★★★
 exit-address-family
!
router bgp 65000 vrf vrf-A
 address-family ipv4 unicast
  redistribute connected
  network 10.1.8.0/24  # ★★★ 显式通告子网 ★★★
 exit-address-family
 !
 address-family l2vpn evpn
  advertise ipv4 unicast  # ★★★ 确保Type 5路由 ★★★
 exit-address-family
!
line vty
