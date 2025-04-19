1. Install kvm related packages
apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils guestfish

2. Download CentOS7 and CentOS8 qcow2 image
wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2
wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2

3. Change passwd for the qcow2 image
virt-customize -a /data/centos8.qcow2 --root-password password:hive
virt-install --os-variant list
osinfo-query os
# If with permission:
setfacl -m u:libvirt-qemu:--x /root

4. Expand the original image[from 10G to 50G]
[CentOS 7]
virt-customize -a ./CentOS-7-x86_64-GenericCloud-2009.qcow2 --root-password password:hive
cp -r CentOS-7-x86_64-GenericCloud-2009.qcow2 centos7.qcow2
virt-filesystems --long --parts --blkdevs -h -a centos7.qcow2 
mv centos7.qcow2 centos7.qcow2.bak
qemu-img create -f qcow2 centos7.qcow2 50G
virt-resize --expand /dev/sda1 centos7.qcow2.bak centos7.qcow2
virt-filesystems --long --parts --blkdevs -h -a centos7.qcow2

[CentOS 8]
virt-customize -a ./CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 --root-password password:hive
cp -r CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2 centos8.qcow2
virt-filesystems --long --parts --blkdevs -h -a centos8.qcow2 
mv centos8.qcow2 centos8.qcow2.bak
qemu-img create -f qcow2 centos8.qcow2 50G
virt-resize --expand /dev/sda1 centos8.qcow2.bak centos8.qcow2
virt-filesystems --long --parts --blkdevs -h -a centos8.qcow2
virt-install --name c8 --memory 2048  --cpu host-model --vcpus=4 --disk /root/kvm/centos8.qcow2,device=disk,bus=virtio --disk size=50 --os-variant centos8 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --import

5. Setup kvm vm
virt-install --name c7 --memory 2048  --cpu host-model --vcpus=4 --disk /root/kvm/centos7.qcow2,device=disk,bus=virtio --disk size=50 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --import

virt-install --name vppc --memory 10240  --cpu host-model --vcpus=8 --disk /root/kvm/vpp1.qcow2,device=disk,bus=virtio --disk size=30 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --import

6. kvm
virsh destroy vppc
virsh undefine vppc
virsh shutdown vppc
virsh start vppc
cd /var/lib/libvirt/images && ls -lrth

