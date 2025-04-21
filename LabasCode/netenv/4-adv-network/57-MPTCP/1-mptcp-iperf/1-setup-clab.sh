#!/bin/bash
set -v
cat <<EOF
The two fe80 addresses are the IPv6 link local addresses configured on the Ethernet (enp2s0) and Wi-Fi (wlp3s0) interfaces of our client host. There are three flags which can be associated with each endpoint identifier:

subflow. When this flag is set, the path manager will try to create a subflow over this interface when a Multipath TCP is created or the interface becomes active while there was an ongoing Multipath TCP connection. This flag is mainly useful for clients.

signal. When this flag is set, the path manager will announce the address of the endpoint over any Multipath TCP connection created using other addresses. This flag can be used on clients or servers. It is mainly useful on servers that have multiple addresses.

backup. This flag can be combined with the two other flags. When combined with the subflow flag, it indicates that a backup subflow will be created. When combined with the signal flag, it indicates that the address will be advertised as a backup address.
EOF

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: mptcp
topology:
  nodes:
    client:
      kind: linux
      image: 192.168.2.100:5000/ucni
      exec:
      - bash -c "sysctl -w net.mptcp.enabled=1"

      - ip addr add 10.10.1.10/24 dev net1
      - ip addr add 10.10.2.10/24 dev net2
      - ip addr add 10.10.3.10/24 dev net3
      - ip addr add 10.10.4.10/24 dev net4
      
      - tc qdisc add dev net1 root netem rate 100mbit
      - tc qdisc add dev net2 root netem rate 100mbit
      - tc qdisc add dev net3 root netem rate 100mbit
      - tc qdisc add dev net4 root netem rate 100mbit

      - ip mptcp limits set subflows 4 add_addr_accepted 4
      - ip mptcp endpoint add 10.10.1.10 dev net1 id 1 subflow
      - ip mptcp endpoint add 10.10.2.10 dev net2 id 2 subflow
      - ip mptcp endpoint add 10.10.3.10 dev net3 id 3 subflow
      - ip mptcp endpoint add 10.10.4.10 dev net4 id 4 subflow

      # mptcpize run iperf3 -c 10.10.1.11

    server:
      kind: linux
      image: 192.168.2.100:5000/ucni
      exec:
      - bash -c "sysctl -w net.mptcp.enabled=1"

      - ip addr add 10.10.1.11/24 dev net1
      - ip addr add 10.10.2.11/24 dev net2
      - ip addr add 10.10.3.11/24 dev net3
      - ip addr add 10.10.4.11/24 dev net4

      - tc qdisc add dev net1 root netem rate 100mbit
      - tc qdisc add dev net2 root netem rate 100mbit
      - tc qdisc add dev net3 root netem rate 100mbit
      - tc qdisc add dev net4 root netem rate 100mbit

      - ip mptcp limits set subflows 4 add_addr_accepted 4
      - ip mptcp endpoint add 10.10.1.11 dev net1 id 1 signal
      - ip mptcp endpoint add 10.10.2.11 dev net2 id 2 signal
      - ip mptcp endpoint add 10.10.3.11 dev net3 id 3 signal
      - ip mptcp endpoint add 10.10.4.11 dev net4 id 4 signal

      - bash -c "mptcpize run iperf3 -s &"

  links:
    - endpoints: ["client:net1", "server:net1"]
    - endpoints: ["client:net2", "server:net2"]
    - endpoints: ["client:net3", "server:net3"]
    - endpoints: ["client:net4", "server:net4"]
EOF
