cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: sonic
topology:
  nodes:
    vyos:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.7
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/vyos.cfg:/opt/vyatta/etc/config/config.boot 
    sonic:
      kind: linux
      image: 192.168.2.100:5000/docker-sonic-vs:2020-11-12
      binds:
        - ./startup-conf/sonic.cfg:/etc/frr/frr.conf
        - ./startup-conf/daemons:/etc/frr/daemons

  links:
    - endpoints: ["vyos:eth1", "sonic:eth1"]
EOF

sleep 5

docker exec -it clab-sonic-sonic bash -c "config interface ip add Ethernet0 10.1.5.11/24 && config interface startup Ethernet0 && config loopback add Loopback0 && config interface ip add Loopback0 2.2.2.2/24 && config interface startup Loopback0"

sleep 5
docker exec -it clab-sonic-sonic bash -c "ip l s eth1 up && service frr restart >/dev/null 2>&1 && service frr restart"

