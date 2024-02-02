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
vppctl set interface state ipip256 up
vppctl set interface unnumbered ipip256 use fpeth1
vppctl ip route add 10.1.8.0/24 via ipip256  $ via route to introduce traffic to GRE tunnel.

                     ipip256-interface  ipip256-interface 
                       10.1.9.11/24 ---  10.1.9.12/24
                           |                  |
10.1.5.11/24---10.1.5.1/24-|       IPIP       |-10.1.8.1/24---10.1.8.12/24
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
vppctl set interface state ipip256 up
vppctl set interface unnumbered ipip256 use fpeth9
vppctl ip route add 10.1.8.0/24 via ipip256

4.2: ipng2
vppctl lcp create fpeth9 host-if fpeth9
ip a a 10.1.9.12/24 dev fpeth9
ip l s fpeth9 up

vppctl create tap id 8 host-ip4-addr 10.1.8.12/24 host-ip4-gw 10.1.8.1
vppctl set interface state tap8 up
vppctl set interface ip address tap8 10.1.8.1/24

vppctl create gre tunnel src 10.1.9.12 dst 10.1.9.11 instance 256
vppctl set interface state ipip256 up
vppctl set interface unnumbered ipip256 use fpeth9
vppctl ip route add 10.1.5.0/24 via ipip256


5. Capture the pcap

vppctl pcap dispatch trace on max 1000 file ipng1.cap buffer-trace dpdk-input 1000
sleep 5
vppctl pcap dispatch trace off



**********************************************************************************
if with real vm: [there is no need to add simu tap interface]
$ ipng1:
vppctl lcp create fpeth9 host-if fpeth9
ip a a 10.1.9.11/24 dev fpeth9
ip l s fpeth9 up

vppctl set interface state fpeth5 up
vppctl set interface ip address fpeth5 10.1.5.1/24

vppctl create gre tunnel src 10.1.9.11 dst 10.1.9.12 instance 256
vppctl set interface state ipip256 up
vppctl set interface unnumbered ipip256 use fpeth9
vppctl ip route add 10.1.8.0/24 via ipip256

$ ipng2:
vppctl lcp create fpeth9 host-if fpeth9
ip a a 10.1.9.12/24 dev fpeth9
ip l s fpeth9 up

vppctl set interface state fpeth8 up
vppctl set interface ip address fpeth8 10.1.8.1/24

vppctl create gre tunnel src 10.1.9.12 dst 10.1.9.11 instance 256
vppctl set interface state ipip256 up
vppctl set interface unnumbered ipip256 use fpeth9
vppctl ip route add 10.1.5.0/24 via ipip256
**********************************************************************************

Frame 8: 5265 bytes on wire (42120 bits), 5265 bytes captured (42120 bits)
VPP Dispatch Trace
NodeName: fpeth9-tx
VPP Buffer Metadata
VPP Buffer Opaque
VPP Buffer Opaque2
VPP Buffer Trace
Ethernet II, Src: RealtekU_6a:18:88 (52:54:00:6a:18:88), Dst: RealtekU_04:fb:2c (52:54:00:04:fb:2c)
Internet Protocol Version 4, Src: 10.1.9.11, Dst: 10.1.9.12
Internet Protocol Version 4, Src: 10.1.5.11, Dst: 10.1.8.12
Internet Control Message Protocol

Frame 9: 2883 bytes on wire (23064 bits), 2883 bytes captured (23064 bits)
VPP Dispatch Trace
NodeName: ethernet-input
VPP Buffer Metadata
VPP Buffer Opaque
VPP Buffer Opaque2
VPP Buffer Trace
Ethernet II, Src: RealtekU_04:fb:2c (52:54:00:04:fb:2c), Dst: RealtekU_6a:18:88 (52:54:00:6a:18:88)
Internet Protocol Version 4, Src: 10.1.9.12, Dst: 10.1.9.11
Internet Protocol Version 4, Src: 10.1.8.12, Dst: 10.1.5.11
Internet Control Message Protocol

