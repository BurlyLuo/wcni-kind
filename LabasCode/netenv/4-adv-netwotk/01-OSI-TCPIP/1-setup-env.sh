#!/bin/bash
set -v

tcp:
# [node: 192.168.2.72]
ip=192.168.2.72
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no root@$ip -p 22 >/dev/null 2>&1
ssh 192.168.2.72 "nc -lk 192.168.2.72 8088"


# [node: 192.168.2.71]
nc 192.168.2.72 8088


udp:
# [node: 192.168.2.72]
nc -l -u 192.168.2.72 8089

tcpdump -pne -i ens160 -w ens160.cap 

