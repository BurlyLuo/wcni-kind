cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: dell
topology:
  nodes:
    sonic:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    tool:
      kind: linux
      image: 192.168.2.100:5000/nettool

  links:
    # sonic-eth1: 10.1.1.10 vyos-eth1: 10.1.1.11
    - endpoints: ["sonic:eth1", "tool:eth1"]
    # sonic-eth2: 10.1.2.10 vyos-eth2: 10.1.2.11
    - endpoints: ["sonic:eth2", "tool:eth2"]
EOF
