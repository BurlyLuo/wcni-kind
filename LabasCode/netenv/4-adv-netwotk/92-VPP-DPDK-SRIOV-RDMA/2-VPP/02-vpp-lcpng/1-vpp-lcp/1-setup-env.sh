#!/bin/bash
set -v

for ip in 192.168.2.71 192.168.2.72; do
    kcli create vm -i ipng -P numcpus=4 -P memory=4096 -P disks=[50] -P nets="[{'name':'brnet','ip':'${ip}','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" $ip
    sleep 1
done
