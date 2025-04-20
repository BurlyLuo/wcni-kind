#!/bin/bash
set -v

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: mptcp
topology:
  nodes:
    client:
      kind: linux
      image: 192.168.2.100:5000/ucni
      exec:
      - ip addr add 10.1.5.10/24 dev net1
      - ip addr add 10.1.8.10/24 dev net2
      
      - ip mptcp limits set subflow 2 add_addr_accepted 2
      - ip mptcp endpoint add 10.1.5.10 dev net1 signal

      # mptcpize run iperf3 -c 10.1.8.11

    server:
      kind: linux
      image: 192.168.2.100:5000/ucni
      exec:
      - ip addr add 10.1.5.11/24 dev net1
      - ip addr add 10.1.8.11/24 dev net2

      - ip mptcp limits set subflow 2 add_addr_accepted 2
      - ip mptcp endpoint add 10.1.5.11 dev net1 signal

      - bash -c "mptcpize run iperf3 -s &"

  links:
    - endpoints: ["client:net1", "server:net1"]
    - endpoints: ["client:net2", "server:net2"]
EOF
