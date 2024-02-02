#!/bin/bash
set -v

{ ip netns del ns1 && ip netns del ns2; } > /dev/null 2>&1

ip netns add ns1
ip netns add ns2

ip l a veth-01 type veth peer name veth-10

ip l s veth-01 netns ns1
ip netns exec ns1 ip l s veth-01 up
ip netns exec ns1 ip a a 10.1.5.10/24 dev veth-01

ip l s veth-10 netns ns2
ip netns exec ns2 ip l s veth-10 up
ip netns exec ns2 ip a a 10.1.5.11/24 dev veth-10

