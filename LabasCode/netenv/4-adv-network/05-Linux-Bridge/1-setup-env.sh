#!/bin/bash
set -v
# https://github.com/beacer/notes/blob/master/kernel/bridging.md
{ ip netns del ns1 && ip netns del ns2; } > /dev/null 2>&1

ip netns add ns1
ip netns add ns2

ip l a br0 type bridge
ip l s br0 up

ip l a int0 type veth peer name br-int0
ip l a int1 type veth peer name br-int1

ip l s int0 netns ns1
ip netns exec ns1 ip l s int0 up
ip netns exec ns1 ip a a 10.1.5.10/24 dev int0

ip l s int1 netns ns2
ip netns exec ns2 ip l s int1 up
ip netns exec ns2 ip a a 10.1.5.11/24 dev int1

ip l s br-int0 master br0
ip l s br-int0 up
ip l s br-int1 master br0
ip l s br-int1 up
