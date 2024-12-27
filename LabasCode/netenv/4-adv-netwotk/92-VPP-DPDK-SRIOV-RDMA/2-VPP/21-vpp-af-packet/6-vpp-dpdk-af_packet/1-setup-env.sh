#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: cnf
topology:
  nodes:
    vpp1:
      kind: linux
      image: 192.168.2.100:5000/dpdk_af_packet_pmd:v1
      cmd: sleep infinity
      #binds:
      #  - startup-conf/vpp1:/etc/vpp
      exec:
        - ip l s dev eth1 address aa:c1:ab:06:5b:01
      env:
        TZ: Asia/Shanghai
          
    vpp2:
      kind: linux
      image: 192.168.2.100:5000/dpdk_af_packet_pmd:v1
      cmd: sleep infinity
      #binds:
      #  - startup-conf/vpp2:/etc/vpp
      exec:
        - ip l s dev eth1 address aa:c1:ab:06:5b:02
      env:
        TZ: Asia/Shanghai

  links:
    - endpoints: ["vpp1:eth1", "macvlan:ens256"]
    - endpoints: ["vpp2:eth1", "macvlan:ens256"]
EOF
