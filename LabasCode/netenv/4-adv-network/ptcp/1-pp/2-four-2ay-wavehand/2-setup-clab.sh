#!/bin/bash
set -v

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: tcp
mgmt:
  ipv6-subnet: ""
  ipv4-subnet: 172.20.20.0/24

topology:
  nodes:

    fin:
      kind: linux
      image: 192.168.2.100:5000/packetdrill:v1
      exec:
      - mount -t debugfs none /sys/kernel/debug
      binds:
        - ./1.pkt:/root/1.pkt

  links:
EOF

