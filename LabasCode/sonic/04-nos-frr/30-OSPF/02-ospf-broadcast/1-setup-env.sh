#!/bin/bash

{ ip l s brx down && brctl delbr brx; } > /dev/null 2>&1
brctl addbr brx;ip l s brx up

cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: ospf
prefix: ""

topology:
  nodes:
    brx:
      kind: bridge

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
        
        # leaf1 to brx
        - ip addr add 192.168.1.1/24 dev eth1

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

        # leaf2 to brx
        - ip addr add 192.168.1.2/24 dev eth1

        # leaf2 to vm3
        - ip a a 10.1.8.254/24 dev eth2

    leaf3:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/ospfd=no/ospfd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/leaf3.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

        # leaf3 to brx
        - ip addr add 192.168.1.3/24 dev eth1

    leaf4:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i 's/ospfd=no/ospfd=yes/;s/zebra=no/zebra=yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/leaf4.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf

        # leaf4 to brx
        - ip addr add 192.168.1.4/24 dev eth1

    vm1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.5.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:05:10
        - ip r r default via 10.1.5.254

    vm2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
        - ip addr add 10.1.8.10/24 dev eth1
        - ip l s eth1 add 00:00:10:01:08:10
        - ip r r default via 10.1.8.254

  links:
    - endpoints: ["leaf1:eth1", "brx:breth1"]
    - endpoints: ["leaf2:eth1", "brx:breth2"]
    - endpoints: ["leaf3:eth1", "brx:breth3"]
    - endpoints: ["leaf4:eth1", "brx:breth4"]
   
    # 10.1.5.10/24
    - endpoints: ["leaf1:eth2", "vm1:eth1"]
    # 10.1.8.10/24
    - endpoints: ["leaf2:eth2", "vm2:eth1"]
EOF
