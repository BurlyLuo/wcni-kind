(This document uses 4.21.0F as an example, but the following instructions apply to all releases starting 4.21.0F)

# import the downloaded cEOS-lab.tar.xz image
docker import cEOS-lab.tar.xz ceosimage:4.21.0F

# create docker instances with needed environment variables
docker create --name=ceos1 --privileged -e INTFTYPE=eth -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.21.0F /sbin/init systemd.setenv=INTFTYPE=eth systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker create --name=ceos2 --privileged -e INTFTYPE=eth -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.21.0F /sbin/init systemd.setenv=INTFTYPE=eth systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker

# create docker networks
docker network create net1
docker network create net2

# connect docker instances to the networks
docker network connect net1 ceos1
docker network connect net1 ceos2
docker network connect net2 ceos1
docker network connect net2 ceos2

# start the instances
docker start ceos1
docker start ceos2

# wait for a few minutes for all EOS agents to start

# issue 'Cli' command to be presented with EOS CLI.

core@core-01 ~ $ docker exec -it ceos1 Cli
localhost>en

localhost#show version
Arista cEOSLab
Hardware version:
Serial number:       N/A
System MAC address:  2623.a993.5502

Software image version: 4.21.0F
Architecture:           i386
Internal build version: 4.21.0F-9441269.4210F
Internal build ID:      0e81f168-216d-4896-b345-5b70ca08f5df

cEOS tools version: 1.1

Uptime:                 7 hours and 27 minutes
Total memory:           8170952 kB
Free memory:            6449840 kB

localhost#show interfaces status
Port       Name        Status       Vlan     Duplex Speed  Type            Flags
Et1                    connected    1        full   unconf EbraTestPhyPort
Et2                    connected    1        full   unconf EbraTestPhyPort

