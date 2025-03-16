From now no, we get the logical about the IPsec tunnel mode. can we ready a demo? Of Course!
Let's do it:

-----------------            -----------------
|      ns1      |            |      ns1      |
|   1.1.1.2/24  |            |   1.1.2.2/24  |
|       |       |            |       |       |
|       |       |            |       |       |
|       |       |            |       |       |
|-------|-------|            |-------|-------|      
      ens160                      ens160
        |----------------------------|
172.18.0.2     ipsec tunnel     172.18.0.3

$ BPF1:
ip netns a ns1
ip l a veth type veth peer name c-eth0 
ip l s veth up
ip a a 1.1.1.1/24 dev veth

ip l s c-eth0 netns ns1
ip netns exec ns1 ip l s c-eth0 up
ip netns exec ns1 ip a a 1.1.1.2/24 dev c-eth0
ip netns exec ns1 ip l s lo up
ip netns exec ns1 ip r a default via 1.1.1.1 dev c-eth0

# ip route add  1.1.2.0/24 via 172.18.0.3 dev ens160[no need]

$ BPF3
ip netns a ns1
ip l a veth type veth peer name c-eth0
ip l s veth up
ip a a 1.1.2.1/24 dev veth

ip l s c-eth0 netns ns1
ip netns exec ns1 ip l s c-eth0 up
ip netns exec ns1 ip a a 1.1.2.2/24 dev c-eth0
ip netns exec ns1 ip l s lo up
ip netns exec ns1 ip r a default via 1.1.2.1 dev c-eth0

# ip route add  1.1.1.0/24 via 172.18.0.2 dev ens160[no need]



$ create the ip xfrm state and ip xfrm policy:
# ID=0x`dd if=/dev/urandom count=4 bs=1 2> /dev/null| xxd -p -c 8
# KEY=0x`dd if=/dev/urandom count=20 bs=1 2> /dev/null| xxd -p -c 40`
ID=0xfe51d978
KEY=0xfa42aa6bc685beb4d967057134dd8e327ca179a6

$ BPF1
ID=0xfe51d978
KEY=0xfa42aa6bc685beb4d967057134dd8e327ca179a6
ip xfrm state add src 172.18.0.2 dst 172.18.0.3 proto esp spi $ID reqid $ID mode tunnel aead 'rfc4106(gcm(aes))' $KEY 128
ip xfrm state add src 172.18.0.3 dst 172.18.0.2 proto esp spi $ID reqid $ID mode tunnel aead 'rfc4106(gcm(aes))' $KEY 128

ip xfrm policy add src 1.1.1.2/24 dst 1.1.2.2/24 dir out tmpl src 172.18.0.2 dst 172.18.0.3 proto esp reqid $ID mode tunnel
ip xfrm policy add src 1.1.2.2/24 dst 1.1.1.2/24 dir fwd tmpl src 172.18.0.3 dst 172.18.0.2 proto esp reqid $ID mode tunnel
ip xfrm policy add src 1.1.2.2/24 dst 1.1.1.2/24 dir in  tmpl src 172.18.0.3 dst 172.18.0.2 proto esp reqid $ID mode tunnel

$ BPF3
ID=0xfe51d978
KEY=0xfa42aa6bc685beb4d967057134dd8e327ca179a6
ip xfrm state add src 172.18.0.3 dst 172.18.0.2 proto esp spi $ID reqid $ID mode tunnel aead 'rfc4106(gcm(aes))' $KEY 128
ip xfrm state add src 172.18.0.2 dst 172.18.0.3 proto esp spi $ID reqid $ID mode tunnel aead 'rfc4106(gcm(aes))' $KEY 128

ip xfrm policy add src 1.1.2.2/24 dst 1.1.1.2/24 dir out tmpl src 172.18.0.3 dst 172.18.0.2 proto esp reqid $ID mode tunnel
ip xfrm policy add src 1.1.1.2/24 dst 1.1.2.2/24 dir fwd tmpl src 172.18.0.2 dst 172.18.0.3 proto esp reqid $ID mode tunnel
ip xfrm policy add src 1.1.1.2/24 dst 1.1.2.2/24 dir in  tmpl src 172.18.0.2 dst 172.18.0.3 proto esp reqid $ID mode tunnel


