#!/bin/bash
set -v
cat <<EOF>clab.yaml | clab deploy -t clab.yaml -
name: wireguard
topology:
  nodes:
    gwx:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip a a 10.1.5.1/24 dev net1
      - ip a a 10.1.8.1/24 dev net2
      - ip a a 10.1.9.1/24 dev net3

    wireguard1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # wireguard configuration:[https://www.wireguard.com/quickstart/]
      # wg genkey | tee privatekey | wg pubkey > publickey && cat privatekey && cat pubkey

      # wg1:private-key: EPWegjOAsrVMhP2QujaAFsGBD6JFLx1E6us9D72T120=
      # wg2:public-key: ++SNCQIpd4em0IzV4dirkR8p65bvwCixq8NafQDfGEU=
      # wg3:public-key: Wtavoi/VXeade/bE5wtn1hcp3QpUNNwEzh+vIPQbqXA=
      
      # echo "EPWegjOAsrVMhP2QujaAFsGBD6JFLx1E6us9D72T120=" | wg set wg0 private-key /dev/stdin [add private-key into wg0 interface]
      # wg set wg0 peer ++SNCQIpd4em0IzV4dirkR8p65bvwCixq8NafQDfGEU= allowed-ips 10.244.2.0/24 endpoint 10.1.8.10:51820 [add peer by public-key]
        - >
          bash -c '
          ip a a 10.244.1.1/24 dev eth1 &&
          ip addr add 10.1.5.10/24 dev eth2 &&
          ip r r default via 10.1.5.1 dev eth2 &&

          ip l a wg0 type wireguard &&
          ip a a 10.244.1.0/24 dev wg0 &&
          wg set wg0 listen-port 51820 &&
          ip l s wg0 up &&
          echo "EPWegjOAsrVMhP2QujaAFsGBD6JFLx1E6us9D72T120=" | wg set wg0 private-key /dev/stdin &&

          wg set wg0 peer ++SNCQIpd4em0IzV4dirkR8p65bvwCixq8NafQDfGEU= allowed-ips 10.244.2.0/24 endpoint 10.1.8.10:51820 &&
          ip r a 10.244.2.0/24 dev wg0 &&

          wg set wg0 peer Wtavoi/VXeade/bE5wtn1hcp3QpUNNwEzh+vIPQbqXA= allowed-ips 10.244.3.0/24 endpoint 10.1.9.10:51820 &&
          ip r a 10.244.3.0/24 dev wg0'

    wireguard2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # wireguard configuration:
      # wg2:private-key: oAExwteyYLvoRP3bz0kN9IkoOLnrYqNkDiR+P55usmo=
      # wg1:public-key: X9SuPta9X1ymiu2fKaKkEQ47a0HZl1Q8YiBpKWLCqho=
      # wg3:public-key: Wtavoi/VXeade/bE5wtn1hcp3QpUNNwEzh+vIPQbqXA=
      - >
        bash -c '
          ip a a 10.244.2.1/24 dev eth1 &&
          ip addr add 10.1.8.10/24 dev eth2 &&
          ip r r default via 10.1.8.1 dev eth2 &&

          ip l a wg0 type wireguard &&
          ip a a 10.244.2.0/24 dev wg0 &&
          wg set wg0 listen-port 51820 &&
          ip l s wg0 up &&
          wg set wg0 private-key <(echo "oAExwteyYLvoRP3bz0kN9IkoOLnrYqNkDiR+P55usmo=") &&

          wg set wg0 peer X9SuPta9X1ymiu2fKaKkEQ47a0HZl1Q8YiBpKWLCqho= allowed-ips 10.244.1.0/24 endpoint 10.1.5.10:51820 &&
          ip r a 10.244.1.0/24 dev wg0 &&

          wg set wg0 peer Wtavoi/VXeade/bE5wtn1hcp3QpUNNwEzh+vIPQbqXA= allowed-ips 10.244.3.0/24 endpoint 10.1.9.10:51820 &&
          ip r a 10.244.3.0/24 dev wg0'

    wireguard3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      # wireguard configuration:
      # wg3:private-key: EH5+5KM1kLmmkmpWushu6RxcQ9LqxJ8vl+dlvZWT+E8=
      # wg1:public-key: X9SuPta9X1ymiu2fKaKkEQ47a0HZl1Q8YiBpKWLCqho=
      # wg2:public-key: ++SNCQIpd4em0IzV4dirkR8p65bvwCixq8NafQDfGEU=
      - >
        bash -c '
          ip a a 10.244.3.1/24 dev eth1 &&
          ip addr add 10.1.9.10/24 dev eth2 &&
          ip r r default via 10.1.9.1 dev eth2 &&

          ip l a wg0 type wireguard &&
          ip a a 10.244.3.0/24 dev wg0 &&
          wg set wg0 listen-port 51820 &&
          ip l s wg0 up &&
          wg set wg0 private-key <(echo "EH5+5KM1kLmmkmpWushu6RxcQ9LqxJ8vl+dlvZWT+E8=") &&

          wg set wg0 peer X9SuPta9X1ymiu2fKaKkEQ47a0HZl1Q8YiBpKWLCqho= allowed-ips 10.244.1.0/24 endpoint 10.1.5.10:51820 &&
          ip r a 10.244.1.0/24 dev wg0 &&

          wg set wg0 peer ++SNCQIpd4em0IzV4dirkR8p65bvwCixq8NafQDfGEU= allowed-ips 10.244.2.0/24 endpoint 10.1.8.10:51820 &&
          ip r a 10.244.2.0/24 dev wg0'

    server1:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.1.10/24 dev net0
      - ip route replace default via 10.244.1.1

    server2:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.2.10/24 dev net0
      - ip route replace default via 10.244.2.1

    server3:
      kind: linux
      image: 192.168.2.100:5000/nettool
      exec:
      - ip addr add 10.244.3.10/24 dev net0
      - ip addr add 10.244.3.11/24 dev net0
      - ip route replace default via 10.244.3.1

  links:
    - endpoints: ["wireguard1:eth1", "server1:net0"]
    - endpoints: ["wireguard2:eth1", "server2:net0"]
    - endpoints: ["wireguard3:eth1", "server3:net0"]
    - endpoints: ["wireguard1:eth2", "gwx:net1"]
    - endpoints: ["wireguard2:eth2", "gwx:net2"]
    - endpoints: ["wireguard3:eth2", "gwx:net3"]
EOF

