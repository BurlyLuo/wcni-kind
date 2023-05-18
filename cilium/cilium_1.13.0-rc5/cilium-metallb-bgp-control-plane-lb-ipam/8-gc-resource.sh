ifconfig br-leaf0 down
brctl delbr br-leaf0
ip l d br-leaf0-net0
ip l d br-leaf0-net1

ifconfig br-leaf1 down
brctl delbr br-leaf1
ip l d br-leaf1-net0
ip l d br-leaf1-net1
