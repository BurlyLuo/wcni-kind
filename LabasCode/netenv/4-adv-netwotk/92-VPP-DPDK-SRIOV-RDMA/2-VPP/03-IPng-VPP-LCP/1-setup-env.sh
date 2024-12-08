0. Download common debian12 qcow2 image
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

1. Install kvm vm:
virt-install --name vppx --memory 10240  --cpu host-model --vcpus=8 --disk /root/kvm/debian/debian12.qcow2,device=disk,bus=virtio --disk size=50 --os-variant debian12 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --network=bridge=vppdpdk9,model=virtio --import

2. Ipng install vpp
apt update
curl -s https://packagecloud.io/install/repositories/fdio/master/script.deb.sh | sudo bash
apt --fix-broken install

mkdir -p /var/log/vpp/
# Reference: you can build by yourself or use ipng.ch done(https://ipng.ch/media/vpp/bookworm/)
[https://ipng.ch/s/articles/2021/12/23/vpp-linux-cp-virtual-machine-playground/   and  how to build custome deb packages: https://fd.io/docs/vpp/v2009/gettingstarted/developers/building.html?highlight=build]

chrom https://ipng.ch/media/
wget -m --no-parent https://ipng.ch/media/vpp/bookworm/24.xx-rc0~xxx-gxxxxxxxx/
dpkg -i ipng.ch/media/vpp/bookworm/24.02-rc0~175-g31d4891cf/*.deb

useradd -m pim && echo "pim:hive" | sudo chpasswd
adduser pim vpp
vppctl show version

3. LCP plugin enable
cat ./startup.conf
# key part:
plugins {
  plugin default { enable }
  plugin lcpng_if_plugin.so { enable }
  plugin lcpng_nl_plugin.so { enable }
  plugin linux_cp_plugin.so { disable }
  plugin dpdk_plugin.so { enable }
  plugin unittest_plugin.so { enable }
}

lcpng {
  #default netns default [if define the netns, need add ns at kernel side firstlly]
  lcp-sync 
  lcp-auto-subint 
}

#lcp interface create:
set interface state fpeth1 up
set interface ip address fpeth1 10.1.5.10/24

lcp create fpeth1 host-if fpeth1
set interface name tap0 tap0-fpeth1

# switch back to kernel side:
ip a
ip r a 114.114.114.114 via 10.1.5.254 dev fpeth1

# switch back to vpp side:
vppctl show ip fib | grep 114.114.114.114 -C 5

# SBR: [Ticket: https://github.com/pimvanpelt/lcpng/issues/10]
ip route add 0.0.0.0/0 via 10.1.5.254 table 100
ip rule add from 10.1.5.0/24 table 100

vppctl trace add virtio-input 1000 
vppctl show trace

vppctl trace add dpdk-input
vppctl show trace


----------------------------------------------------------------------------------------------------------------------------
Soluton2: Use ipng.ch's kvm snapshot image[https://ipng.ch/s/articles/2021/12/23/vpp-linux-cp-virtual-machine-playground/]
----------------------------------------------------------------------------------------------------------------------------
brctl addbr empty
virsh define vpp-proto-bookworm.xml
virsh start vpp-proto-bookworm

virsh console vpp-proto-bookworm
username: root
passwd: IPng loves VPP

