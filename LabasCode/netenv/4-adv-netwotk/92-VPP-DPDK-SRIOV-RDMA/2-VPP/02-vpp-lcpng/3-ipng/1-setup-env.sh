#/bin/bash
wget https://ipng.ch/media/vpp-proto/vpp-proto-bookworm.qcow2.lrz
brctl addbr empty
lrzip -d vpp-proto-bookworm.qcow2.lrz

virsh define ./vpp-proto-bookworm/vpp-proto-bookworm.xml
virsh start vpp-proto-bookworm

virsh console vpp-proto-bookworm
username: root
passwd: IPng loves VPP


