#!/bin/bash

# BPF71:
ip netns add ns1

ip l a br0 type bridge
ip l s br0 up

ip l a int0 type veth peer name br-int0

ip l s int0 netns ns1
ip netns exec ns1 ip l s int0 up
ip netns exec ns1 ip a a 10.1.5.10/24 dev int0
ip netns exec ns1 ip r a default via 10.1.5.1

ip l s br-int0 master br0
ip l s br-int0 up


ip a a 10.1.5.1/24 dev br0

ip r a 10.1.8.0/24 via 192.168.2.73 dev ens160 

# BPF73:
ip netns add ns1

ip l a br0 type bridge
ip l s br0 up

ip l a int0 type veth peer name br-int0

ip l s int0 netns ns1
ip netns exec ns1 ip l s int0 up
ip netns exec ns1 ip a a 10.1.8.10/24 dev int0
ip netns exec ns1 ip r a default via 10.1.8.1

ip l s br-int0 master br0
ip l s br-int0 up


ip a a 10.1.8.1/24 dev br0

ip r a 10.1.5.0/24 via 192.168.2.71 dev ens160

