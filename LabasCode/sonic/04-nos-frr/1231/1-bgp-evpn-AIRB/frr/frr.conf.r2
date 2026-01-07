frr defaults datacenter
log file /var/log/frr/bgpd.log
!
router bgp 65000
 bgp router-id 192.168.100.2
 no bgp default ipv4-unicast
 neighbor FABRIC peer-group
 neighbor FABRIC remote-as internal
 neighbor 192.168.100.1 peer-group FABRIC
 !
 address-family l2vpn evpn
  neighbor FABRIC activate
  neighbor FABRIC soft-reconfiguration inbound
  advertise-all-vni
  advertise-svi-ip
 exit-address-family
exit
!
line vty
