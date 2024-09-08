#!/bin/bash
for vm in {0,1,2}; do
  ip="192.168.2.21$vm"
 
  kcli create vm -i ubuntu2204 \
    -P memory=4096 \
    -P numcpus=4 \
    -P disks=[50] \
    -P rootpassword=hive \
    -P nets="[{'name':'brnet','ip':'$ip','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" \
    -P cmds='["apt -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' \
    vm$vm
done

