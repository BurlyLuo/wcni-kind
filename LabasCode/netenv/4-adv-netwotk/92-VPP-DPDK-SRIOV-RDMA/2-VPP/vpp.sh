#!/bin/bash
ip l s eth1 down
ip l s eth2 down
ip l s eth3 down

modprobe vfio_pci
echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode
echo 0 > /sys/bus/pci/devices/0000\:02\:00.0/numa_node
echo 0 > /sys/bus/pci/devices/0000\:03\:00.0/numa_node
echo 0 > /sys/bus/pci/devices/0000\:04\:00.0/numa_node

dpdk-devbind -u 02:00.0
dpdk-devbind -u 03:00.0
dpdk-devbind -u 04:00.0

dpdk-devbind -b vfio-pci 02:00.0
dpdk-devbind -b vfio-pci 03:00.0
dpdk-devbind -b vfio-pci 04:00.0
