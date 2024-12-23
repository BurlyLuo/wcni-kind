#!/bin/bash
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
        - bash -c 'apt update ; apt -y install tcpdump lrzsz net-tools'
      env:
        TZ: Asia/Shanghai
          
    vpp2:
      kind: linux
      image: ligato/vpp-base
      binds:
        - startup-conf/vpp2:/etc/vpp
      exec:
        - bash -c 'apt update ; apt -y install tcpdump lrzsz net-tools'
      env:
        TZ: Asia/Shanghai

  links:
    - endpoints: ["vpp1:eth1", "vpp2:eth1"]
EOF
