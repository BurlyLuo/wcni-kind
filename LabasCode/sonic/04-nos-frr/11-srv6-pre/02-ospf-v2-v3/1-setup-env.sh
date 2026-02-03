cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: frr-ospf
prefix: ""

topology:
  kinds:
    linux:
      sysctls:
        net.ipv4.ip_forward: 1
        net.ipv6.conf.all.forwarding: 1

  nodes:
    r1:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i '/^ospfd=/s/no/yes/;/^ospf6d=/s/no/yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/r1.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@r1]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

    r2:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i '/^ospfd=/s/no/yes/;/^ospf6d=/s/no/yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/r2.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@r2]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

    r3:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i '/^ospfd=/s/no/yes/;/^ospf6d=/s/no/yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/r3.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@r3]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

    h1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.1.10/24 dev eth1
        - ip addr add 2001:db8:100::10/64 dev eth1
        - ip route r default via 10.1.1.1
        - ip -6 route r default via 2001:db8:100::1

    h2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.2.2.10/24 dev eth1
        - ip addr add 2001:db8:200::10/64 dev eth1
        - ip route r default via 10.2.2.1
        - ip -6 route r default via 2001:db8:200::1

    h3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.3.3.10/24 dev eth1
        - ip addr add 2001:db8:300::10/64 dev eth1
        - ip route r default via 10.3.3.1
        - ip -6 route r default via 2001:db8:300::1

  links:
    - endpoints: ["r1:eth1", "r2:eth1"]
    - endpoints: ["r2:eth2", "r3:eth1"]
    - endpoints: ["r3:eth2", "r1:eth2"]
    
    - endpoints: ["r1:eth3", "h1:eth1"]
    - endpoints: ["r2:eth3", "h2:eth1"]
    - endpoints: ["r3:eth3", "h3:eth1"]
EOF
