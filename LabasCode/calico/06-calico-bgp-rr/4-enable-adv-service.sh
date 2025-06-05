# https://docs.tigera.io/archive/v3.23/networking/advertise-service-ips#advertise-service-load-balancer-ip-addresses
# 1. Advertise serviceClusterIPs
calicoctl --allow-version-mismatch patch BGPConfig default --patch '{"spec": {"serviceClusterIPs": [{"cidr": "10.96.0.0/16"}]}}'

# 2. Advertise external IP address
calicoctl --allow-version-mismatch patch bgpconfig default --patch '{"spec": {"serviceExternalIPs": [{"cidr": "20.0.0.0/16"}, {"cidr": "30.0.0.0/16"}]}}'

# 3. Advertise service load balancer IP addresses
calicoctl --allow-version-mismatch patch bgpconfig default --patch '{"spec": {"serviceLoadBalancerIPs": [{"cidr": "40.0.0.0/16"}]}}'

# 4. List bgpconfig
calicoctl --allow-version-mismatch get bgpconfig default -o yaml
