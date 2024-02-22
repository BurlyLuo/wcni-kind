https://docs.cilium.io/en/stable/network/lb-ipam/#lb-ipam
LoadBalancer IP Address Management (LB IPAM)
LB IPAM is a feature that allows Cilium to assign IP addresses to Services of type LoadBalancer. This functionality is usually left up to a cloud provider, however, when deploying in a private cloud environment, these facilities are not always available.

LB IPAM works in conjunction with features such as Cilium BGP Control Plane (Beta) and L2 Announcements / L2 Aware LB (Beta). Where LB IPAM is responsible for allocation and assigning of IPs to Service objects and other features are responsible for load balancing and/or advertisement of these IPs.

Use Cilium BGP Control Plane (Beta) to advertise the IP addresses assigned by LB IPAM over BGP and L2 Announcements / L2 Aware LB (Beta) to advertise them locally.

LB IPAM is always enabled but dormant. The controller is awoken when the first IP Pool is added to the cluster.
