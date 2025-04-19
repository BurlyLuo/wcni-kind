#!/bin/bash
set -v

{ ip netns del ns1 && ip netns del ns2 && ovs-vsctl del-br br-ovs0; } > /dev/null 2>&1

ip netns add ns1
ip netns add ns2

ovs-vsctl add-br br-ovs0
ip l s br-ovs0 up

ip l a int0 type veth peer name ovs-int0
ip l a int1 type veth peer name ovs-int1

ip l s int0 netns ns1
ip netns exec ns1 ip l s int0 up
ip netns exec ns1 ip a a 10.1.5.10/24 dev int0

ip l s int1 netns ns2
ip netns exec ns2 ip l s int1 up
ip netns exec ns2 ip a a 10.1.5.11/24 dev int1

ovs-vsctl add-port br-ovs0 ovs-int0
ip l s ovs-int0 up

ovs-vsctl add-port br-ovs0 ovs-int1
ip l s ovs-int1 up
