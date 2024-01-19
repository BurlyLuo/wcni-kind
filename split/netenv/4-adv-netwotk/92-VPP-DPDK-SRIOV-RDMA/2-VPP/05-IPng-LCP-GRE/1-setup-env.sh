1. vm install
virt-install --name ipng1 --memory 8192 --cpu host-model --vcpus=8 --disk /root/kvm/debian/ipng1.qcow2,device=disk,bus=virtio --disk size=50 --os-variant debian12 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --network=bridge=vppdpdk9,model=virtio --import

virt-install --name ipng2 --memory 8192 --cpu host-model --vcpus=8 --disk /root/kvm/debian/ipng2.qcow2,device=disk,bus=virtio --disk size=50 --os-variant debian12 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --network=bridge=vppdpdk9,model=virtio --import

2. vpp install
apt update
curl -s https://packagecloud.io/install/repositories/fdio/master/script.deb.sh | sudo bash
apt --fix-broken install
mkdir -p /var/log/vpp/
wget -m --no-parent https://ipng.ch/media/vpp/bookworm/24.02-rc0~175-g31d4891cf/
dpkg -i ipng.ch/media/vpp/bookworm/24.02-rc0~175-g31d4891cf/*.deb
useradd -m pim && echo "pim:hive" | sudo chpasswd
adduser pim vpp
vppctl show version verbose

3. case topo 
vppctl create gre tunnel src 172.12.1.11 dst 172.12.1.12 instance 256
vppctl set interface state gre256 up
vppctl set interface unnumbered gre256 use fpeth1
vppctl ip route add 10.1.8.0/24 via gre256  $ via route to introduce traffic to GRE tunnel.

                     gre256-interface  gre256-interface 
                       10.1.9.11/24 ---  10.1.9.12/24
                           |                  |
10.1.5.11/24---10.1.5.1/24-|       GRE        |-10.1.8.1/24---10.1.8.12/24
                         ipng1              ipng2 


4. GRE case scripts
4.1: ipng1
vppctl lcp create fpeth9 host-if fpeth9
ip a a 10.1.9.11/24 dev fpeth9
ip l s fpeth9 up

vppctl create tap id 5 host-ip4-addr 10.1.5.11/24 host-ip4-gw 10.1.5.1
vppctl set interface state tap5 up
vppctl set interface ip address tap5 10.1.5.1/24

vppctl create gre tunnel src 10.1.9.11 dst 10.1.9.12 instance 256
vppctl set interface state gre256 up
vppctl set interface unnumbered gre256 use fpeth9
vppctl ip route add 10.1.8.0/24 via gre256

4.2: ipng2
vppctl lcp create fpeth9 host-if fpeth9
ip a a 10.1.9.12/24 dev fpeth9
ip l s fpeth9 up

vppctl create tap id 8 host-ip4-addr 10.1.8.12/24 host-ip4-gw 10.1.8.1
vppctl set interface state tap8 up
vppctl set interface ip address tap8 10.1.8.1/24

vppctl create gre tunnel src 10.1.9.12 dst 10.1.9.11 instance 256
vppctl set interface state gre256 up
vppctl set interface unnumbered gre256 use fpeth9
vppctl ip route add 10.1.5.0/24 via gre256


5. Capture the pcap

vppctl pcap dispatch trace on max 1000 file ipng1.cap buffer-trace dpdk-input 1000
sleep 5
vppctl pcap dispatch trace off

