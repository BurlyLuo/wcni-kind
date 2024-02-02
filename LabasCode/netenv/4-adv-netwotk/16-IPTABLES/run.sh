#!/bin/bash
set -v
docker run --hostname c1 --name c1 --privileged --security-opt seccomp=unconfined --rm -td --tmpfs /tmp --tmpfs /run --volume /var --volume /lib/modules:/lib/modules:ro 192.168.2.100:5000/kindest/node:v1.27.3

docker run --hostname c2 --name c2 --privileged --security-opt seccomp=unconfined --rm -td --tmpfs /tmp --tmpfs /run --volume /var --volume /lib/modules:/lib/modules:ro 192.168.2.100:5000/kindest/node:v1.27.3

containerlab tools veth create -a c1:eth1 -b c2:eth1

docker exec -it c1 ip a a 10.1.5.10/24 dev eth1
docker exec -it c1 ip l s eth1 up

docker exec -it c2 ip a a 10.1.5.11/24 dev eth1
docker exec -it c2 ip l s eth1 up

