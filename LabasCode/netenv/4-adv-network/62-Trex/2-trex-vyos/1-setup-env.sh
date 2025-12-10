cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: vs
topology:
  nodes:
    vyos:
      kind: linux
      image: 192.168.2.100:5000/vyos/vyos:1.4.9
      cmd: /sbin/init
      binds:
        - /lib/modules:/lib/modules
        - ./startup-conf/br-boot.cfg:/opt/vyatta/etc/config/config.boot

    client:
      kind: linux
      image: 192.168.2.100:5000/trexcisco/trex:4.1
      exec:
        - ip addr add 10.1.5.10/24 dev eth1
        - ip addr add 10.1.5.11/24 dev eth2
      binds:
        - ./imix.py:/root/imix.py
        - ./trex_cfg.yaml:/etc/trex_cfg.yaml

      ports:
        - 4507:4507
        - 4500:4500
        - 4501:4501
     
      env:
        COLUMNS: "130"
        LINES: "100"
      # port0: 10.1.5.10 eth1
      # port1: 10.1.5.11 eth2
 
      # Run TRex in Stateless mode
      # ./t-rex-64 -i
      
      # stty cols 160 rows 50
      # Start traffic on port 0 (imix profile)
      # ./trex-console
      # start -f /root/imix.py -m 10kpps --port 0
      # tui

  links:
    - endpoints: ["vyos:eth1", "client:eth1"]
      mtu: 1500
    - endpoints: ["vyos:eth2", "client:eth2"]
      mtu: 1500
EOF
