cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
# topo:
#     loopback                                    loopback  
# 2001:db8:1111::/128                         2001:db8:2222::/128
#     +-------+                                   +-------+
#     |       | eth1                         eth1 |       |
#     |  R1   |-----------------------------------|  R2   |
#     |       |                                   |       |
#     +-------+                                   +-------+

name: frr-isis
prefix: ""

topology:
  nodes:
    # PROVIDER EDGE
    r1:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i '/^bgpd=/s/no/yes/;/^isisd=/s/no/yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/r1.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf


    r2:
      kind: linux
      image: quay.io/weiluo/frrouting/frr:10.5.0
      cmd: sh -c "sed -i '/^bgpd=/s/no/yes/;/^isisd=/s/no/yes/' /etc/frr/daemons && /usr/lib/frr/docker-start"
      binds:
        - /lib/modules:/lib/modules
        - ./frr/r2.conf:/etc/frr/frr.conf
      exec:
        - bash -c "echo 'PS1=\"[\\\\u@\\\\h]\\\\$ \"' > /root/.bashrc"
        - touch /etc/frr/vtysh.conf


  links:
    - endpoints: ["r1:eth1", "r2:eth1"]
EOF

