cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic-bgp:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    sonic1:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    sonic2:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.10/24 dev eth1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.1.5.11/24 dev eth1

  links:
    - endpoints: ["sonic-bgp:eth2", "sonic1:eth2"]
    - endpoints: ["sonic-bgp:eth3", "sonic2:eth2"]
    - endpoints: ["sonic1:eth1", "server1:eth1"]
    - endpoints: ["sonic2:eth1", "server2:eth1"]
EOF
