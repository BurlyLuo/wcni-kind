ip tuntap add tap1 mode tap 
ip l s tap1 up
ip a a 1.1.1.1/24 dev tap1
