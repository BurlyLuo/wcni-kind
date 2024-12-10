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











##############################################################################################################################
[root@rowan> install-kvm-vm]# virsh console c7
Connected to domain 'c7'
Escape character is ^] (Ctrl + ])

CentOS Linux 7 (Core)
Kernel 3.10.0-1160.el7.x86_64 on an x86_64

localhost login: root
Password: 
[root@localhost ~]# df -h 
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        896M     0  896M   0% /dev
tmpfs           919M     0  919M   0% /dev/shm
tmpfs           919M   17M  903M   2% /run
tmpfs           919M     0  919M   0% /sys/fs/cgroup
/dev/vda1       200G  848M  200G   1% /
tmpfs           184M     0  184M   0% /run/user/0
[root@localhost ~]# 

[root@rowan> install-kvm-vm]# virt-customize -a ./CentOS-7-x86_64-GenericCloud-2009.qcow2 --root-password password:hive
[   0.0] Examining the guest ...
[   7.4] Setting a random seed
[   7.4] Setting passwords
[   8.7] Finishing off
[root@rowan> install-kvm-vm]# cp -r CentOS-7-x86_64-GenericCloud-2009.qcow2 centos7.qcow2
[root@rowan> install-kvm-vm]# virt-filesystems --long --parts --blkdevs -h -a centos7.qcow2 
Name       Type       MBR  Size  Parent
/dev/sda1  partition  83   8.0G  /dev/sda
/dev/sda   device     -    8.0G  -
[root@rowan> install-kvm-vm]# mv centos7.qcow2 centos7.qcow2.bak
[root@rowan> install-kvm-vm]# qemu-img create -f qcow2 centos7.qcow2 200G
Formatting 'centos7.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib size=214748364800 lazy_refcounts=off refcount_bits=16
[root@rowan> install-kvm-vm]# virt-resize --expand /dev/sda1 centos7.qcow2.bak centos7.qcow2
[   0.0] Examining centos7.qcow2.bak
**********

Summary of changes:

/dev/sda1: This partition will be resized from 8.0G to 200.0G.  The 
filesystem xfs on /dev/sda1 will be expanded using the ‘xfs_growfs’ 
method.

**********
[   3.4] Setting up initial partition table on centos7.qcow2
[   4.3] Copying /dev/sda1
$<2>◑ 30% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════════════════════════════════════════════════════════════════════════════════⟧ --$<2>◒ 37% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒══════════════════════════════════════════════════════════════════════════════════════⟧ --$<2>◐ 44% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═════════════════════════════════════════════════════════════════════════════⟧ 00$<2>◓ 51% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═══════════════════════════════════════════════════════════════════⟧ 00$<2>◑ 56% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═══════════════════════════════════════════════════════════⟧ 00$<2>◒ 64% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═════════════════════════════════════════════════⟧ 00$<2>◐ 71% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════════════════════════⟧ 00$<2>◓ 77% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════════════════⟧ 00$<2>◑ 79% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════════════⟧ 00$<2>◒ 84% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒══════════════════════⟧ 00$<2>◐ 91% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════⟧ 00$<2>◓ 98% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═══⟧ 00$<2> 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ 00:00
[  12.1] Expanding /dev/sda1 using the ‘xfs_growfs’ method

Resize operation completed with no errors.  Before deleting the old disk, 
carefully check that the resized disk boots and works correctly.
[root@rowan> install-kvm-vm]# virt-resize --expand /dev/sda1 centos7.qcow2.bak centos7.qcow2
[   0.0] Examining centos7.qcow2.bak
**********

Summary of changes:

/dev/sda1: This partition will be resized from 8.0G to 200.0G.  The 
filesystem xfs on /dev/sda1 will be expanded using the ‘xfs_growfs’ 
method.

**********
[   3.3] Setting up initial partition table on centos7.qcow2
[   4.2] Copying /dev/sda1
$<2>◑ 37% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒══════════════════════════════════════════════════════════════════════════════════════⟧ --$<2>◒ 44% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════════════════════════════════════════════════════════════⟧ --$<2>◐ 51% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒══════════════════════════════════════════════════════════════════⟧ 00$<2>◓ 57% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒══════════════════════════════════════════════════════════⟧ 00$<2>◑ 64% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════════════════════════════════⟧ 00$<2>◒ 72% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒══════════════════════════════════════⟧ 00$<2>◐ 76% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════════════════⟧ 00$<2>◓ 80% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═══════════════════════════⟧ 00$<2>◑ 85% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒════════════════════⟧ 00$<2>◒ 92% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═══════════⟧ 00$<2>◐ 99% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒═⟧ 00$<2> 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ 00:00
[  11.7] Expanding /dev/sda1 using the ‘xfs_growfs’ method

Resize operation completed with no errors.  Before deleting the old disk, 
carefully check that the resized disk boots and works correctly.
[root@rowan> install-kvm-vm]# virt-filesystems --long --parts --blkdevs -h -a centos7.qcow2
Name       Type       MBR  Size  Parent
/dev/sda1  partition  83   200G  /dev/sda
/dev/sda   device     -    200G  -
[root@rowan> install-kvm-vm]# virt-install --name c7 --memory 2048  --cpu host-model --vcpus=4 --disk /root/kvm/centos7.qcow2,device=disk,bus=virtio --disk size=200 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --import --noconsole
usage: virt-install --name NAME --memory MB STORAGE INSTALL [options]
virt-install: error: unrecognized arguments: --noconsole
[root@rowan> install-kvm-vm]# virt-install --name c7 --memory 2048  --cpu host-model --vcpus=4 --disk /root/kvm/centos7.qcow2,device=disk,bus=virtio --disk size=200 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --import --noautoconsole
ERROR    Error: --disk /root/kvm/centos7.qcow2,device=disk,bus=virtio: Size must be specified for non existent volume 'centos7.qcow2'
[root@rowan> install-kvm-vm]# ll
total 2617912
-rw-r--r-- 1 root root       677 Nov 27 10:17 0-vlan-spec-location
-rw-r--r-- 1 root root      2441 Nov 19 19:17 1-CentOS7-8.md
-rw-r--r-- 1 root root      1629 Nov 19 19:17 2-Ubuntu2204.md
-rw-r--r-- 1 root root      1826 Nov 19 19:17 3-Rocky9.0.md
-rw-r--r-- 1 root root      2960 Nov 19 19:24 4-Win10.md
-rw-r--r-- 1 root root 902758400 Dec 10 16:47 centos7.qcow2
-rw-r--r-- 1 root root 888995840 Dec 10 16:44 centos7.qcow2.bak
-rw-r--r-- 1 root root 888995840 Dec 10 16:44 CentOS-7-x86_64-GenericCloud-2009.qcow2
-rw-r--r-- 1 root root      2544 Nov 19 19:17 kvm-reference-tmp
-rw-r--r-- 1 root root      3978 Nov 19 19:17 Rocky9.qcow2.rr
[root@rowan> install-kvm-vm]# mv centos7.qcow2 centosx.qcow2
[root@rowan> install-kvm-vm]# virt-install --name c7 --memory 2048  --cpu host-model --vcpus=4 --disk ./centosx.qcow2,device=disk,bus=virtio --disk size=200 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --import --noautoconsole --check all=off
WARNING  The requested volume capacity will exceed the available pool space when the volume is fully allocated. (204800 M requested capacity > 86988 M available)

Starting install...
Allocating 'c7.qcow2'                                                                                                           |    0 B  00:00:00 ... 
Creating domain...                                                                                                              |    0 B  00:00:00     
Domain creation completed.
[root@rowan> install-kvm-vm]# ll

[root@rowan> install-kvm-vm]# virsh console c7
Connected to domain 'c7'
Escape character is ^] (Ctrl + ])

CentOS Linux 7 (Core)
Kernel 3.10.0-1160.el7.x86_64 on an x86_64

localhost login: root
Password:
[root@localhost ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        896M     0  896M   0% /dev
tmpfs           919M     0  919M   0% /dev/shm
tmpfs           919M   17M  903M   2% /run
tmpfs           919M     0  919M   0% /sys/fs/cgroup
/dev/vda1       200G  848M  200G   1% /
tmpfs           184M     0  184M   0% /run/user/0
[root@localhost ~]#

