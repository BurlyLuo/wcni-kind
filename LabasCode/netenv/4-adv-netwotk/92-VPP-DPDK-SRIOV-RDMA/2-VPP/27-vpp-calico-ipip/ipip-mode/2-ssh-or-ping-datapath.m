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

5. [vpp fib table]
vpp# show ip fib 192.168.2.99
ipv4-VRF:0, fib_index:0, flow hash:[src dst sport dport proto flowlabel ] epoch:0 flags:none locks:[adjacency:1, recursive-resolution:1, default-route:1, ]
192.168.2.99/32 fib:0 index:43 locks:2
  adjacency refs:1 entry-flags:attached, src-flags:added,contributing,active, cover:24
    path-list:[72] locks:2 uPRF-list:54 len:1 itfs:[1, ]
      path:[80] pl-index:72 ip4 weight=1 pref=0 attached-nexthop:  oper-flags:resolved,
        192.168.2.99 host-eth0
      [@0]: ipv4 via 192.168.2.99 host-eth0: mtu:1500 next:5 flags:[features ] 86f7f9f77594525400e2f6490800
    Extensions:
     path:80 adj-flags:[refines-cover]
 forwarding:   unicast-ip4-chain
  [@0]: dpo-load-balance: [proto:ip4 index:44 buckets:1 uRPF:54 to:[2552:506972]]
    [0] [@5]: ipv4 via 192.168.2.99 host-eth0: mtu:1500 next:5 flags:[features ] 86f7f9f77594525400e2f6490800
 
