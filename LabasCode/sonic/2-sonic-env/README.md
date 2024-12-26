#  Creating a SoNIC NOS Virtual Lab

The example files from the tutorial [Creating a SoNIC NOS Virtual Lab](http://192.168.2.100/http/sonic-lab.html)

brctl addbr mgtbr0
brctl addbr vmbr0

The default login to SoNIC: admin/YourPaSsWoRd
sudo config reload
<img src="https://github.com/adamdunstan/sonic-nos-vm-lab/blob/main/Sonic-basic-net.png">

It creates a network of three VMs running the sonic-vs image

The consist of the VM configuration xml and associated config_db to create the SoNIC VM's

