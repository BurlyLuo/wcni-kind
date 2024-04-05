echo "
nodeSelector: Nodes which are selected by this label selector will apply the given policy

 virtualRouters: One or more peering configurations outlined below. Each peering configuration can be thought of as a BGP router instance.

    virtualRouters[*].localASN: The local ASN for this peering configuration

    virtualRouters[*].serviceSelector: Services which are selected by this label selector will be announced.

    virtualRouters[*].exportPodCIDR: Whether to export the private pod CIDR block to the listed neighbors

    virtualRouters[*].neighbors: A list of neighbors to peer with
        neighbors[*].peerAddress: The address of the peer neighbor
        neighbors[*].peerPort: Optional TCP port number of the neighbor. 1-65535 are valid values and defaults to 179 when unspecified.
        neighbors[*].peerASN: The ASN of the peer
        neighbors[*].eBGPMultihopTTL: Time To Live (TTL) value used in BGP packets. The value 1 implies that eBGP multi-hop feature is disabled.
        neighbors[*].connectRetryTimeSeconds: Initial value for the BGP ConnectRetryTimer (RFC 4271, Section 8). Defaults to 120 seconds.
        neighbors[*].holdTimeSeconds: Initial value for the BGP HoldTimer (RFC 4271, Section 4.2). Defaults to 90 seconds.
        neighbors[*].keepAliveTimeSeconds: Initial value for the BGP KeepaliveTimer (RFC 4271, Section 8). Defaults to 30 seconds.
        neighbors[*].gracefulRestart.enabled: The flag to enable graceful restart capability.
        neighbors[*].gracefulRestart.restartTimeSeconds: The restart time advertised to the peer (RFC 4724 section 4.2).

"

kubectl delete ciliumbgppeeringpolicies rack0 rack1 > /dev/null 2>&1

cat <<EOF | kubectl apply -f -
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumBGPPeeringPolicy
metadata:
  name: rack0
spec:
  nodeSelector:
    matchLabels:
      rack: rack0
  virtualRouters:
  - localASN: 65005
    exportPodCIDR: true
    neighbors:
    - peerAddress: "10.1.5.1/24"
      peerASN: 65005
      gracefulRestart:
        enabled: true
        restartTimeSeconds: 120
      families:
      - afi: ipv4
        safi: unicast
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumBGPPeeringPolicy
metadata:
  name: rack1
spec:
  nodeSelector:
    matchLabels:
      rack: rack1
  virtualRouters:
  - localASN: 65008
    exportPodCIDR: true
    neighbors:
    - peerAddress: "10.1.8.1/24"
      peerASN: 65008
      gracefulRestart:
        enabled: true
        restartTimeSeconds: 120
      families:
      - afi: ipv4
        safi: unicast
EOF

