cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ospf
prefix: ""

topology:
  nodes:
    leaf1:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/ospfd=no/ospfd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/leaf1.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf
         
        # leaf1 to spine
        - ip addr add 192.168.1.1/31 dev eth1

        # leaf1 to vm1
        - ip a a 10.1.5.254/24 dev eth2

    leaf2:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/ospfd=no/ospfd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/leaf2.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

        # leaf2 to spine
        - ip addr add 192.168.1.3/31 dev eth1

        # leaf2 to vm3
        - ip a a 10.1.8.254/24 dev eth2

    spine:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/ospfd=no/ospfd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/spine.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

        # spine to leaf1 and leaf2
        - ip addr add 192.168.1.0/31 dev eth1
        - ip addr add 192.168.1.2/31 dev eth2

    vm1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.5.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:05:10
        - ip r r default via 10.1.5.254

    vm3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.8.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:08:10
        - ip r r default via 10.1.8.254

  links:
    # 192.168.1.0/31 <> 192.168.1.1/31
    - endpoints: ["spine:eth1", "leaf1:eth1"]
    # 192.168.1.2/31 <> 192.168.1.3/31
    - endpoints: ["spine:eth2", "leaf2:eth1"]
   
    # 10.1.5.10/24
    - endpoints: ["leaf1:eth2", "vm1:eth1"]
    # 10.1.8.10/24
    - endpoints: ["leaf2:eth2", "vm3:eth1"]
EOF
