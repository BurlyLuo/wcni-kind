#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vm
topology:
  nodes:
    r1:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.10/24 dev net0

    r2:
      kind: linux
      image: 192.168.2.100:5000/xcni
      exec:
      - ip addr add 10.1.5.11/24 dev net0

  links:
    - endpoints: ["r1:net0", "r2:net0"]
EOF

