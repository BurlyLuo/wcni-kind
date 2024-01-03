#!/bin/bash

docker run -d --privileged --name lbdsr0a -h lbdsr0a snpsuen/ebpf-xdp:v03
docker exec -it lbdsr0a bash


