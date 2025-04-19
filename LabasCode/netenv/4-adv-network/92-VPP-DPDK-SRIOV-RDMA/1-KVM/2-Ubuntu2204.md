1. Install kvm related packages
apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils guestfish

2. Download ubuntu2204 kvm image
wget https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img

3. Change passwd for the qcow2 image
virt-customize -a ./ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img --root-password password:hive
virt-install --os-variant list
osinfo-query os
# If with permission:
setfacl -m u:libvirt-qemu:--x /root

4. Expand the original image[from 10G to 50G]
virt-customize -a ./ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img --root-password password:hive
qemu-img resize ./ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img 50G
qemu-img info ./ubuntu-22.04-server-cloudimg-amd64-disk-kvm.img
virt-install --name vppu --memory 2048  --cpu host-model --vcpus=4 --disk /root/kvm/centos7.qcow2,device=disk,bus=virtio --disk size=50 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --import
virsh console vppu
#> lsblk
#> apt -y install cloud-guest-utils
#> growpart /dev/vda 1
#> lsblk
#> resize2fs /dev/vda1
#> df -h

5. Setup kvm vm
virt-install --name vppu --memory=8192  --cpu host-model --vcpus=8 --disk /root/kvm/Ubuntu2204/2204.img,device=disk,bus=virtio --disk size=60 --os-variant ubuntu22.04 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --import

6. kvm
virsh destroy vppu
virsh undefine vppu
virsh shutdown vppu
virsh start vppu

cd /var/lib/libvirt/images && ls -lrth

