Neighbor Discovery
When kube-proxy replacement is enabled, Cilium does L2 neighbor discovery of nodes in the cluster. This is required for the service load-balancing to populate L2 addresses for backends since it is not possible to dynamically resolve neighbors on demand in the fast-path.

In Cilium 1.10 or earlier, the agent itself contained an ARP resolution library where it triggered discovery and periodic refresh of new nodes joining the cluster. The resolved neighbor entries were pushed into the kernel and refreshed as PERMANENT entries. In some rare cases, Cilium 1.10 or earlier might have left stale entries behind in the neighbor table causing packets between some nodes to be dropped. To skip the neighbor discovery and instead rely on the Linux kernel to discover neighbors, you can pass the --enable-l2-neigh-discovery=false flag to the cilium-agent. However, note that relying on the Linux Kernel might also cause some packets to be dropped. For example, a NodePort request can be dropped on an intermediate node (i.e., the one which received a service packet and is going to forward it to a destination node which runs the selected service endpoint). This could happen if there is no L2 neighbor entry in the kernel (due to the entry being garbage collected or given that the neighbor resolution has not been done by the kernel). This is because it is not possible to drive the neighbor resolution from BPF programs in the fast-path e.g. at the XDP layer.

From Cilium 1.11 onwards, the neighbor discovery has been fully reworked and the Cilium internal ARP resolution library has been removed from the agent. The agent now fully relies on the Linux kernel to discover gateways or hosts on the same L2 network. Both IPv4 and IPv6 neighbor discovery is supported in the Cilium agent. As per our recent kernel work presented at Plumbers, “managed” neighbor entries have been upstreamed and will be available in Linux kernel v5.16 or later which the Cilium agent will detect and transparently use. In this case, the agent pushes down L3 addresses of new nodes joining the cluster as externally learned “managed” neighbor entries. For introspection, iproute2 displays them as “managed extern_learn”. The “extern_learn” attribute prevents garbage collection of the entries by the kernel’s neighboring subsystem. Such “managed” neighbor entries are dynamically resolved and periodically refreshed by the Linux kernel itself in case there is no active traffic for a certain period of time. That is, the kernel attempts to always keep them in REACHABLE state. For Linux kernels v5.15 or earlier where “managed” neighbor entries are not present, the Cilium agent similarly pushes L3 addresses of new nodes into the kernel for dynamic resolution, but with an agent triggered periodic refresh. For introspection, iproute2 displays them only as “extern_learn” in this case. If there is no active traffic for a certain period of time, then a Cilium agent controller triggers the Linux kernel-based re-resolution for attempting to keep them in REACHABLE state. The refresh interval can be changed if needed through a --arping-refresh-period=30s flag passed to the cilium-agent. The default period is 30s which corresponds to the kernel’s base reachable time.

The neighbor discovery supports multi-device environments where each node has multiple devices and multiple next-hops to another node. The Cilium agent pushes neighbor entries for all target devices, including the direct routing device. Currently, it supports one next-hop per device. The following example illustrates how the neighbor discovery works in a multi-device environment. Each node has two devices connected to different L3 networks (10.69.0.64/26 and 10.69.0.128/26), and global scope addresses each (10.69.0.1/26 and 10.69.0.2/26). A next-hop from node1 to node2 is either 10.69.0.66 dev eno1 or 10.69.0.130 dev eno2. The Cilium agent pushes neighbor entries for both 10.69.0.66 dev eno1 and 10.69.0.130 dev eno2 in this case.

+---------------+     +---------------+
|    node1      |     |    node2      |
| 10.69.0.1/26  |     | 10.69.0.2/26  |
|           eno1+-----+eno1           |
|           |   |     |   |           |
| 10.69.0.65/26 |     |10.69.0.66/26  |
|               |     |               |
|           eno2+-----+eno2           |
|           |   |     | |             |
| 10.69.0.129/26|     | 10.69.0.130/26|
+---------------+     +---------------+
With, on node1:

ip route show
10.69.0.2
        nexthop via 10.69.0.66 dev eno1 weight 1
        nexthop via 10.69.0.130 dev eno2 weight 1

ip neigh show
10.69.0.66 dev eno1 lladdr 96:eb:75:fd:89:fd extern_learn  REACHABLE
10.69.0.130 dev eno2 lladdr 52:54:00:a6:62:56 extern_learn  REACHABLE
