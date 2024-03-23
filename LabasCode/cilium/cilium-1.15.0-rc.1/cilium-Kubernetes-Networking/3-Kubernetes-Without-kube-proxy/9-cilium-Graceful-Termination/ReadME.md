https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/#graceful-termination
Cilium’s eBPF kube-proxy replacement supports graceful termination of service endpoint pods. The feature requires at least Kubernetes version 1.20, and the feature gate EndpointSliceTerminatingCondition needs to be enabled. By default, the Cilium agent then detects such terminating Pod events, and increments the metric k8s_terminating_endpoints_events_total. If needed, the feature can be disabled with the configuration option enable-k8s-terminating-endpoint.

The cilium agent feature flag can be probed by running cilium-dbg status command:

kubectl -n kube-system exec ds/cilium -- cilium-dbg status --verbose
[...]
KubeProxyReplacement Details:
 [...]
 Graceful Termination:  Enabled
[...]
When Cilium agent receives a Kubernetes update event for a terminating endpoint, the datapath state for the endpoint is removed such that it won’t service new connections, but the endpoint’s active connections are able to terminate gracefully. The endpoint state is fully removed when the agent receives a Kubernetes delete event for the endpoint. The Kubernetes pod termination documentation contains more background on the behavior and configuration using terminationGracePeriodSeconds. There are some special cases, like zero disruption during rolling updates, that require to be able to send traffic to Terminating Pods that are still Serving traffic during the Terminating period, the Kubernetes blog Advancements in Kubernetes Traffic Engineering explains it in detail.

