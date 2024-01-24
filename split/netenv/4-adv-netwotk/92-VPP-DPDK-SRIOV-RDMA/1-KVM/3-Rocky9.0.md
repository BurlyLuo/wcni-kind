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
[Rocky 8]
virt-customize -a ./https://download.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud.latest.x86_64.qcow2 --root-password password:hive
cp -r ./Rocky-8-GenericCloud.latest.x86_64.qcow2 r8.qcow2
qemu-img resize r8.qcow2 50G
virt-install --name r8 --memory 2048  --cpu host-model --vcpus=4 --disk /root/kvm/rocky/r8.qcow2,device=disk,bus=virtio --disk size=20 --os-variant rocky8 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --network=bridge=vppdpdk9,model=virtio --import
virsh console r8
#> lsblk
#> growpart /dev/vda 5
#> lsblk
#> xfs_growfs /
#> df -h

6. setup vm
virt-install --name r8 --memory 2048  --cpu host-model --vcpus=4 --disk /root/kvm/rocky/r8.qcow2,device=disk,bus=virtio --disk size=20 --os-variant rocky8 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --network=bridge=vppdpdk9,model=virtio --import
