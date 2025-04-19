https://doc.dpdk.org/dts/test_plans/dynamic_config_test_plan.html?highlight=promiscuous
.. SPDX-License-Identifier: BSD-3-Clause
   Copyright(c) 2010-2017 Intel Corporation

==================================
Dynamic Driver Configuration Tests
==================================

The purpose of this test is to check that it is possible to change the
configuration of a port dynamically. The following command can be used
to change the promiscuous mode of a specific port::

  set promisc PORTID on|off

A traffic generator sends traffic with a different destination mac
address than the one that is configured on the port. Once the
``testpmd`` application is started, it is possible to display the
statistics of a port using::

  show port stats PORTID

When promiscuous mode is disabled, packet must not be received. When
it is enabled, packets must be received. The change occurs without
stopping the device or restarting the application.


Prerequisites
=============

If using vfio the kernel must be >= 3.6+ and VT-d must be enabled in bios.When
using vfio, use the following commands to load the vfio driver and bind it
to the device under test::

   modprobe vfio
   modprobe vfio-pci
   usertools/dpdk-devbind.py --bind=vfio-pci device_bus_id

Connect the traffic generator to one of the ports (8 in this example).
The size of the packets is not important, in this example it was 64.

Start the testpmd application.

Use the 'show port' command to see the MAC address and promiscuous mode for port 8.
The default value for promiscuous mode should be enabled::

   testpmd> show port info 8

   ********************* Infos for port 8  *********************
   MAC address: 00:1B:21:6D:A3:6E
   Link status: up
   Link speed: 1000 Mbps
   Link duplex: full-duplex
   Promiscuous mode: enabled
   Allmulticast mode: disabled


Test Case: Default Mode
=======================

The promiscuous mode should be enabled by default.
In promiscuous mode all packets should be received.

Read the stats for port 8 before sending packets.::

   testpmd> show port stats 8

    ######################## NIC statistics for port 8  ########################
    RX-packets: 1          RX-errors: 0         RX-bytes: 64
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Send a packet with destination MAC address different than the port 8 address.::

   testpmd> show port stats 8

    ######################## NIC statistics for port 8  ########################
    RX-packets: 2          RX-errors: 0         RX-bytes: 128
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that the packet was received (RX-packets incremented).
Send a packet with with destination MAC address equal with the port 8 address.::

   testpmd> show port stats 8

    ######################## NIC statistics for port 8  ########################
    RX-packets: 3          RX-errors: 0         RX-bytes: 192
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that the packet was received (RX-packets incremented).


Test Case: Disable Promiscuous Mode
===================================

Disable promiscuous mode and verify that the packets are received only for the
packet with destination address matching the port 8 address.::

   testpmd> set promisc 8 off

Send a packet with destination MAC address different than the port 8 address.::

   testpmd> show port stats 8

    ######################## NIC statistics for port 8  ########################
    RX-packets: 3          RX-errors: 0         RX-bytes: 192
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that no packet was received (RX-packets is the same).

Send a packet with destination MAC address equal to the port 8 address.::

    ######################## NIC statistics for port 8  ########################
    RX-packets: 4          RX-errors: 0         RX-bytes: 256
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that the packet was received (RX-packets incremented).



Test Case: Enable Promiscuous Mode
==================================

Verify that promiscuous mode is still disabled:::

   testpmd> show port info 8

   ********************* Infos for port 8  *********************
   MAC address: 00:1B:21:6D:A3:6E
   Link status: up
   Link speed: 1000 Mbps
   Link duplex: full-duplex
   Promiscuous mode: disabled
   Allmulticast mode: disabled

Enable promiscuous mode and verify that the packets are received for any
destination MAC address.::

   testpmd> set promisc 8 on
   testpmd> show port stats 8

    ######################## NIC statistics for port 8  ########################
    RX-packets: 4          RX-errors: 0         RX-bytes: 256
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################
    testpmd> show port stats 8

Send a packet with destination MAC address different than the port 8 address.::

   testpmd> show port stats 8

    ######################## NIC statistics for port 8  ########################
    RX-packets: 5          RX-errors: 0         RX-bytes: 320
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that the packet was received (RX-packets incremented).

Send a packet with with destination MAC address equal with the port 8 address.::

   testpmd> show port stats 8

    ######################## NIC statistics for port 8  ########################
    RX-packets: 6          RX-errors: 0         RX-bytes: 384
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that the packet was received (RX-packets incremented).

Test Case: Disable Promiscuous Mode broadcast
=============================================

Disable promiscuous mode and verify that the packets are received broadcast packet.::

   testpmd> set promisc all off
   testpmd> set fwd io
   testpmd> clear port stats all

Send a packet with destination MAC address different than the port 0 address.::

   testpmd> show port stats 1

    ######################## NIC statistics for port 1  ########################
    RX-packets: 0          RX-errors: 0         RX-bytes: 0
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that no packet was fwd (port 1 TX-packets is 0)::

   testpmd> clear port stats all

Send a broadcast packet::

    ######################## NIC statistics for port 1  ########################
    RX-packets: 0          RX-errors: 0         RX-bytes: 0
    TX-packets: 1          TX-errors: 0         TX-bytes: 80
    ############################################################################

Verify that the packet was received and fwd(TX-packets is 1).

Test Case: Disable Promiscuous Mode Multicast
=============================================

Disable promiscuous mode and verify that the packets are received multicast packet.::

   testpmd> set promisc all off
   testpmd> set fwd io
   testpmd> clear port stats all
   testpmd> set allmulti all off

Send a packet with destination MAC is multicast mac eg: 01:00:00:33:00:01.::

   testpmd> show port stats 1

    ######################## NIC statistics for port 1  ########################
    RX-packets: 0          RX-errors: 0         RX-bytes: 0
    TX-packets: 0          TX-errors: 0         TX-bytes: 0
    ############################################################################

Verify that no packet was fwd (port 1 TX-packets is 0)::

   testpmd> clear port stats all
   testpmd> set allmulti all on

Send a packet with destination MAC is Multicast mac eg: 01:00:00:33:00:01.::

    ######################## NIC statistics for port 1  ########################
    RX-packets: 0          RX-errors: 0         RX-bytes: 0
    TX-packets: 1          TX-errors: 0         TX-bytes: 80
    ############################################################################

Verify that the packet was received and fwd(TX-packets is 1).
