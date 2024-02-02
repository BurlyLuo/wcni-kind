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

                      10.1.9.11/24  ---  10.1.9.12/24
                           |                  |
10.1.5.11/24---10.1.5.1/24-|      VxLAN       |-10.1.8.1/24---10.1.8.12/24
                    |     ipng1              ipng2  |
                  loop0                           loop0


4. GRE case scripts [https://zhuanlan.zhihu.com/p/540447990]
4.1: ipng1
vppctl set interface state fpeth9 up
vppctl set interface ip address fpeth9 10.1.9.11/24
$ create bridge domain
vppctl create bridge-domain 11 learn 1 forward 1 uu-flood 1 flood 1 arp-term 0
vppctl create vxlan tunnel src 10.1.9.11 dst 10.1.9.12 vni 11 decap-next l2
vppctl set interface l2 bridge vxlan_tunnel0 11
$ into bridge domain
vppctl loopback create mac 1a:2b:3c:4d:5e:5f
vppctl set interface l2 bridge loop0 11 bvi
vppctl set interface state loop0 up
vppctl set interface ip address loop0 10.1.5.1/24
vppctl set interface state fpeth5 up
vppctl set interface l2 bridge fpeth5 11
$ route to 10.1.8.0/24 
vppctl ip route add 10.1.8.0/24 via loop0 

4.2: ipng2
vppctl set interface state fpeth9 up
vppctl set interface ip address fpeth9 10.1.9.12/24

vppctl create bridge-domain 11 learn 1 forward 1 uu-flood 1 flood 1 arp-term 0
vppctl create vxlan tunnel src 10.1.9.12 dst 10.1.9.11 vni 11 decap-next l2
vppctl set interface l2 bridge vxlan_tunnel0 11

vppctl loopback create mac 1a:2b:3c:4d:5e:8f
vppctl set interface l2 bridge loop0 11 bvi
vppctl set interface state loop0 up
vppctl set interface ip address loop0 10.1.8.1/24
vppctl set interface state fpeth8 up
vppctl set interface l2 bridge fpeth8 11

vppctl ip route add 10.1.5.0/24 via loop0 

5. Capture the pcap

vppctl pcap dispatch trace on max 1000 file ipng1.cap buffer-trace dpdk-input 1000
sleep 5
vppctl pcap dispatch trace off


Frame 16: 5808 bytes on wire (46464 bits), 5808 bytes captured (46464 bits)
VPP Dispatch Trace
NodeName: fpeth9-tx
VPP Buffer Metadata
VPP Buffer Opaque
VPP Buffer Opaque2
VPP Buffer Trace
Ethernet II, Src: RealtekU_6a:18:88 (52:54:00:6a:18:88), Dst: RealtekU_04:fb:2c (52:54:00:04:fb:2c)
Internet Protocol Version 4, Src: 10.1.9.11, Dst: 10.1.9.12
User Datagram Protocol, Src Port: 45281, Dst Port: 4789
Virtual eXtensible Local Area Network
Ethernet II, Src: 1a:2b:3c:4d:5e:5f (1a:2b:3c:4d:5e:5f), Dst: RealtekU_a2:56:2d (52:54:00:a2:56:2d)
Internet Protocol Version 4, Src: 10.1.5.11, Dst: 10.1.8.12
Internet Control Message Protocol

Frame 17: 2962 bytes on wire (23696 bits), 2962 bytes captured (23696 bits)
VPP Dispatch Trace
NodeName: ethernet-input
VPP Buffer Metadata
VPP Buffer Opaque
VPP Buffer Opaque2
VPP Buffer Trace
Ethernet II, Src: RealtekU_04:fb:2c (52:54:00:04:fb:2c), Dst: RealtekU_6a:18:88 (52:54:00:6a:18:88)
Internet Protocol Version 4, Src: 10.1.9.12, Dst: 10.1.9.11
User Datagram Protocol, Src Port: 62975, Dst Port: 4789
Virtual eXtensible Local Area Network
Ethernet II, Src: 1a:2b:3c:4d:5e:8f (1a:2b:3c:4d:5e:8f), Dst: RealtekU_de:32:61 (52:54:00:de:32:61)
Internet Protocol Version 4, Src: 10.1.8.12, Dst: 10.1.5.11
Internet Control Message Protocol
