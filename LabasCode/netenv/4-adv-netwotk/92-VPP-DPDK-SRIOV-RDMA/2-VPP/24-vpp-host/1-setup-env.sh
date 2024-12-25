#!/bin/bash
set -v

{ ip l s brvpp down && brctl delbr brvpp; } > /dev/null 2>&1
brctl addbr brvpp;ip l s brvpp up

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
    - endpoints: ["vpp1:eth1", "host:vpp1"]
    - endpoints: ["vpp2:eth1", "host:vpp2"]
EOF

ip l s vpp1 master brvpp
ip l s vpp2 master brvpp
 
