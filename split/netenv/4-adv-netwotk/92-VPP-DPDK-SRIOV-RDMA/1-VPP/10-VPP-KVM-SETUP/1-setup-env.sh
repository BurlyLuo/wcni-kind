#!/bin/bash

cp -r /root/kvm/Ubuntu2204/ubuntu /root/kvm/Ubuntu2204/

virt-install --name vppu1 --memory=8192  --cpu host-model --vcpus=8 --disk /root/kvm/Ubuntu2204/u1.img,device=disk,bus=virtio --disk size=30 --os-variant ubuntu22.04 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --import

virt-install --name vppu2 --memory=8192  --cpu host-model --vcpus=8 --disk /root/kvm/Ubuntu2204/u2.img,device=disk,bus=virtio --disk size=30 --os-variant ubuntu22.04 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --import

[install vpp]
https://packagecloud.io/fdio
https://packagecloud.io/fdio/master
https://packagecloud.io/fdio/release

curl -s https://packagecloud.io/install/repositories/fdio/master/script.deb.sh | sudo bash
apt-get install -y vpp vpp-plugin-core vpp-plugin-dpdk && apt-get install -y vpp-plugin-devtools vpp-ext-deps python3-vpp-api vpp-dbg vpp-dev
systemctl restart vpp

vppctl set interface ip address GigabitEthernet2/0/0 10.1.5.11/24
vppctl set interface state GigabitEthernet2/0/0 up
vppctl set interface ip address GigabitEthernet3/0/0 10.1.8.11/24
vppctl set interface state GigabitEthernet3/0/0 up
vppctl ip route add 0.0.0.0/0 via 10.1.5.254 GigabitEthernet2/0/0

vppctl set interface ip address GigabitEthernet2/0/0 10.1.5.12/24
vppctl set interface state GigabitEthernet2/0/0 up
vppctl set interface ip address GigabitEthernet3/0/0 10.1.8.12/24
vppctl set interface state GigabitEthernet3/0/0 up
vppctl ip route add 0.0.0.0/0 via 10.1.5.254 GigabitEthernet2/0/0
