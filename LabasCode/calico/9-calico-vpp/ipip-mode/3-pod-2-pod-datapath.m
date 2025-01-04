1. [pod list][k3s1: 192.168.2.51 k3s2: 192.168.2.52]
# k get pods -owide 
NAME         READY   STATUS    RESTARTS      AGE   IP             NODE   NOMINATED NODE   READINESS GATES
wluo-b7hrg   1/1     Running   1 (18h ago)   19h   172.18.74.69   k3s2   <none>           <none>
wluo-zhgfq   1/1     Running   2 (65m ago)   19h   172.18.79.33   k3s1   <none>           <none>

2. [pod 172.18.79.33 to pod 172.18.74.69]
kernel PtP to vpp with tun device
vpp quary ip fib to encap ipip pcaket to dst_node[k3s2(192.168.2.52)]

vpp# show ip fib 172.18.74.69
ipv4-VRF:0, fib_index:0, flow hash:[src dst sport dport proto flowlabel ] epoch:0 flags:none locks:[adjacency:1, recursive-resolution:1, default-route:1, ]
172.18.74.69/32 fib:0 index:47 locks:3
  recursive-resolution refs:1 entry-flags:attached, src-flags:added,contributing,active, cover:148
    path-list:[263] locks:2 uPRF-list:178 len:1 itfs:[15, ]
      path:[283] pl-index:263 ip4 weight=1 pref=0 attached-nexthop:  oper-flags:resolved,
        172.18.74.69 ipip0 (p2p)
      [@0]: ipv4 [features] via 0.0.0.0 ipip0: mtu:9000 next:14 flags:[features fixup-ip4o4 ] 45000000000000004004f542c0a80233c0a80234
             stacked-on entry:42:
               [@2]: ipv4 via 192.168.2.52 host-eth0: mtu:1500 next:5 flags:[features ] 52540031763e525400e2f6490800

 forwarding:   unicast-ip4-chain
  [@0]: dpo-load-balance: [proto:ip4 index:50 buckets:1 uRPF:178 to:[0:0]]
    [0] [@6]: ipv4 [features] via 0.0.0.0 ipip0: mtu:9000 next:14 flags:[features fixup-ip4o4 ] 45000000000000004004f542c0a80233c0a80234
        stacked-on entry:42:
          [@2]: ipv4 via 192.168.2.52 host-eth0: mtu:1500 next:5 flags:[features ] 52540031763e525400e2f6490800
