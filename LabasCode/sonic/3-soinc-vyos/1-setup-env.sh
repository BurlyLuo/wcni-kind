cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    sonic:
      kind: sonic-vm
      image: 192.168.2.100:5000/sonic:202305
      # startup-config: ./clab-vs/sonic/config/config_db.json

    vyos:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules 
        - ./startup-conf/vyos.cfg:/opt/vyatta/etc/config/config.boot

  links:
    # sonic-eth1: 10.1.1.10 vyos-eth1: 10.1.1.11
    - endpoints: ["sonic:eth1", "vyos:eth1"]
    # sonic-eth2: 10.1.2.10 vyos-eth2: 10.1.2.11
    - endpoints: ["sonic:eth2", "vyos:eth2"]
EOF
