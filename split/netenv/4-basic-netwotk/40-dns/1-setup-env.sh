#!/bin/bash
set -v
docker run --hostname dns --name dns --privileged --security-opt seccomp=unconfined --rm -td --tmpfs /tmp --tmpfs /run --volume /var --volume /lib/modules:/lib/modules:ro 192.168.2.100:5000/kindest/node:v1.27.3


