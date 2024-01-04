#!/bin/bash

virt-install --name vpp1 --memory 10240  --cpu host-model --vcpus=8 --disk /root/kvm/vpp1.qcow2,device=disk,bus=virtio --disk size=30 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk1,model=virtio --network=bridge=vppdpdk2,model=virtio --import

ssh root@$vpp1_ip_eth0

yum list && yum update -y 
yum install -y epel-release mbedtls python36

cat <<EOF | >/etc/yum.repos.d/fdio-release.repo
[fdio_release]
name=fdio_release
baseurl=https://packagecloud.io/fdio/release/el/7/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/fdio/release/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

yum clean all
yum -q makecache -y --disablerepo='*' --enablerepo='fdio_release'

yum list vpp* && yum install -y vpp vpp-api-lua vpp-api-python vpp-api-python3 vpp-debuginfo vpp-devel vpp-ext-deps vpp-lib vpp-plugins vpp-selinux-policy
systemctl start vpp && systemctl enable vpp

ip l s eth1 down && ip l s eth2 down 
lshw -class network -businfo
modprobe vfio_pci
echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode
./dpdk.py --bind=vfio-pci eth1
./dpdk.py --bind=vfio-pci eth2

vi /etc/vpp/startup.conf

add:
dpdk {
  dev 0000:02:00.0 {
      name fpeth1  
  }
  dev 0000:03:00.0 {
      name fpeth2
  }
}

systemctl start vpp
vppctl set interface ip address fpeth1 10.1.8.10/24
vppctl set interface state fpeth1 up

vppctl set interface ip address fpeth2 10.1.1.10/24
vppctl set interface state fpeth2 up

vppctl show pci
vppctl show hard
vppctl show int
vppctl show plugins
