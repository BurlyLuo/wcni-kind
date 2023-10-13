#!/bin/bash
set -v
docker run --hostname c1 --name c1 --privileged --security-opt seccomp=unconfined --rm -td --tmpfs /tmp --tmpfs /run --volume /var --volume /lib/modules:/lib/modules:ro 192.168.2.100:5000/kindest/node:v1.27.3

ip l a eth1 type veth peer name root-eth1
ip a a 10.1.5.1/24 dev root-eth1
ip l s root-eth1 up 

container_pid=$(docker inspect -f '{{.State.Pid}}' c1)
ln -s /proc/$container_pid/ns/net /var/run/netns/$container_pid
ip link set eth1 netns $container_pid

docker exec -it c1 ip a a 10.1.5.10/24 dev eth1
docker exec -it c1 ip l s eth1 up
docker exec -it c1 ip r r default via 10.1.5.1 dev eth1

iptables -t nat -A POSTROUTING -s 10.1.5.10 -o brroot -j SNAT --to-source 192.168.2.99

