1. [install guide]
   https://github.com/projectcalico/vpp-dataplane/issues/222#issuecomment-2547436335

2. [kernel side]
   https://docs.tigera.io/calico/latest/reference/vpp/host-network#when-vpp-starts
   re-create tap inerface same name with befroe. <driver___virtio_net -> driver___tun>|<ethtool -i eth0>
 
3. [kernel to vpp]: 
   ping same-subnet ip to capture the pcap.
   # ping 192.168.2.99
   capture at k3s1 node: tcpdump -pne -i eth0 icmp (1st_dst_mac: is tap interface at vpp side)

4. [vpp to host(192.168.2.99)]
   tcpdump -pne -i brnet icmp (2st_src_mac: is phy interface at vpp side)
 
