#!/bin/bash
# vpp> show hard> qdisc-bypass-enable
# If there is a requirement to load the network with many packets in a similar
# fashion as pktgen does, you might set the following option after socket
# creation:

#    int one = 1;
#    setsockopt(fd, SOL_PACKET, PACKET_QDISC_BYPASS, &one, sizeof(one));

# This has the side-effect, that packets sent through PF_PACKET will bypass the
# kernel's qdisc layer and are forcedly pushed to the driver directly. Meaning,
# packet are not buffered, tc disciplines are ignored, increased loss can occur
# and such packets are also not visible to other PF_PACKET sockets anymore. So,
# you have been warned; generally, this can be useful for stress testing various
# components of a system.

set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cnf
topology:
  nodes:
    vpp1:
      kind: linux
      image: ligato/vpp-base
      binds:
        - startup-conf/vpp1:/etc/vpp
      exec:
        - ip l s dev eth1 address aa:c1:ab:06:5b:01
        - bash -c 'apt update ; apt -y install tcpdump lrzsz net-tools'
      env:
        TZ: Asia/Shanghai
          
    vpp2:
      kind: linux
      image: ligato/vpp-base
      binds:
        - startup-conf/vpp2:/etc/vpp
      exec:
        - ip l s dev eth1 address aa:c1:ab:06:5b:02
        - bash -c 'apt update ; apt -y install tcpdump lrzsz net-tools'
      env:
        TZ: Asia/Shanghai

  links:
    - endpoints: ["vpp1:eth1", "macvlan:ens256"]
    - endpoints: ["vpp2:eth1", "macvlan:ens256"]
EOF
