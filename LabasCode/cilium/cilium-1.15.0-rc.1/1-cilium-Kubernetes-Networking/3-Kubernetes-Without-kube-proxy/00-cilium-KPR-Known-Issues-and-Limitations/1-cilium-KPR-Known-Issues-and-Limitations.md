Known Issues
For clusters deployed with Cilium version 1.11.14 or earlier, service backend entries could be leaked in the BPF maps in some instances. The known cases that could lead to such leaks are due to race conditions between deletion of a service backend while it’s terminating, and simultaneous deletion of the service the backend is associated with. This could lead to duplicate backend entries that could eventually fill up the cilium_lb4_backends_v2 map. In such cases, you might see error messages like these in the Cilium agent logs:

Unable to update element for cilium_lb4_backends_v2 map with file descriptor 15: the map is full, please consider resizing it. argument list too long
While the leak was fixed in Cilium version 1.11.15, in some cases, any affected clusters upgrading from the problematic cilium versions 1.11.14 or earlier to any subsequent versions may not see the leaked backends cleaned up from the BPF maps after the Cilium agent restarts. The fixes to clean up leaked duplicate backend entries were backported to older releases, and are available as part of Cilium versions v1.11.16, v1.12.9 and v1.13.2. Fresh clusters deploying Cilium versions 1.11.15 or later don’t experience this leak issue.

For more information, see this GitHub issue.

Limitations
Cilium’s eBPF kube-proxy replacement currently cannot be used with IPsec Transparent Encryption.

Cilium’s eBPF kube-proxy replacement relies upon the socket-LB feature which uses eBPF cgroup hooks to implement the service translation. Using it with libceph deployments currently requires support for the getpeername(2) hook address translation in eBPF, which is only available for kernels v5.8 and higher.

In order to support nfs in the kernel with the socket-LB feature, ensure that kernel commit 0bdf399342c5 ("net: Avoid address overwrite in kernel_connect") is part of your underlying kernel. Linux kernels v6.6 and higher support it. Older stable kernels are TBD. For a more detailed discussion see GitHub issue 21541.

Cilium’s DSR NodePort mode currently does not operate well in environments with TCP Fast Open (TFO) enabled. It is recommended to switch to snat mode in this situation.

Cilium’s eBPF kube-proxy replacement does not support the SCTP transport protocol. Only TCP and UDP is supported as a transport for services at this point.

Cilium’s eBPF kube-proxy replacement does not allow hostPort port configurations for Pods that overlap with the configured NodePort range. In such case, the hostPort setting will be ignored and a warning emitted to the Cilium agent log. Similarly, explicitly binding the hostIP to the loopback address in the host namespace is currently not supported and will log a warning to the Cilium agent log.

When Cilium’s kube-proxy replacement is used with Kubernetes versions(< 1.19) that have support for EndpointSlices, Services without selectors and backing Endpoints don’t work. The reason is that Cilium only monitors changes made to EndpointSlices objects if support is available and ignores Endpoints in those cases. Kubernetes 1.19 release introduces EndpointSliceMirroring controller that mirrors custom Endpoints resources to corresponding EndpointSlices and thus allowing backing Endpoints to work. For a more detailed discussion see GitHub issue 12438.

When deployed on kernels older than 5.7, Cilium is unable to distinguish between host and pod namespaces due to the lack of kernel support for network namespace cookies. As a result, Kubernetes services are reachable from all pods via the loopback address.

The neighbor discovery in a multi-device environment doesn’t work with the runtime device detection which means that the target devices for the neighbor discovery doesn’t follow the device changes.

When socket-LB feature is enabled, pods sending (connected) UDP traffic to services can continue to send traffic to a service backend even after it’s deleted. Cilium agent handles such scenarios by forcefully terminating pod sockets in the host network namespace that are connected to deleted backends, so that the pods can be load-balanced to active backends. This functionality requires these kernel configs to be enabled: CONFIG_INET_DIAG, CONFIG_INET_UDP_DIAG and CONFIG_INET_DIAG_DESTROY. If you have application pods (not deployed in the host network namespace) making long-lived connections using (connected) UDP, you can enable bpf-lb-sock-hostns-only in order to enable the socket-LB feature only in the host network namespace.
