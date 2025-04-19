{ ip netns del ns1 && ip netns del ns2; } > /dev/null 2>&1

ip netns add ns1
ip netns add ns2

ip l a br0 type bridge
ip l s br0 up

ip l a int0 type veth peer name br-int0
ip l a int1 type veth peer name br-int1

ip l s int0 netns ns1
ip netns exec ns1 ip l s int0 up
ip netns exec ns1 ip a a 100.1.5.10/24 dev int0
ip netns exec ns1 ip r a default via 100.1.5.1 dev int0
ip netns exec ns1 ip l s lo up

ip l s int1 netns ns2
ip netns exec ns2 ip l s int1 up
ip netns exec ns2 ip a a 100.1.8.10/24 dev int1
ip netns exec ns2 ip r a default via 100.1.8.1 dev int1
ip netns exec ns2 ip l s lo up

ip l s br-int0 master br0
ip l s br-int0 up
ip l s br-int1 master br0
ip l s br-int1 up

ip a a 100.1.5.1/24 dev br0
ip a a 100.1.8.1/24 dev br0

# openssl server
  # ip netns exec ns2 openssl s_server -cert ./ecdsa.crt -key ./ecdsa.key -port 50008 -tls1_3 -ciphersuites TLS_AES_256_GCM_SHA384

# openssl client
  # ip netns exec ns1 openssl s_client -connect 100.1.8.10:50008 -tls1_3 -ciphersuites TLS_AES_256_GCM_SHA384 -CAfile ./ecdsa.crt
