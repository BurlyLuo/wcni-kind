#!/bin/bash
set -v

for ip in 192.168.2.55 192.168.2.56; do
    kcli create vm -i rockylinux9 -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'${ip}','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'}]" rdma-$(echo $ip | awk -F "." '{print $NF}')
    sleep 1
done
