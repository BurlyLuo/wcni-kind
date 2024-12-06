# kcli render -f ./all_parameters.yml -c
# cat /var/lib/cloud/instances/vm/scripts/runcmd
# dnf --enablerepo=devel install libpcap-devel libnet-devel

# [root@rowan> images]# cp -r openEuler2403 openEuler2403.bak
[root@rowan> images]# virt-customize -a /var/lib/libvirt/images/openEuler2403 --edit '/etc/default/grub:s/GRUB_CMDLINE_LINUX=".*"/GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0 rootfstype=ext4 quiet oops=panic softlockup_panic=1 nmi_watchdog=1 rd.shell=0 selinux=0 crashkernel=256M panic=3 net.ifnames=0"/g'
[   0.0] Examining the guest ...
[   3.7] Setting a random seed
[   3.8] Editing: /etc/default/grub
[   3.9] Finishing off
[root@rowan> images]# 
[root@rowan> images]# virt-cat -a /var/lib/libvirt/images/openEuler2403 /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0 rootfstype=ext4 quiet oops=panic softlockup_panic=1 nmi_watchdog=1 rd.shell=0 selinux=0 crashkernel=256M panic=3 net.ifnames=0"
GRUB_DISABLE_RECOVERY="true"
GRUB_DISABLE_OS_PROBER="true"
[root@rowan> images]# virt-customize -a /var/lib/libvirt/images/openEuler2403 --run-command 'grub2-mkconfig -o /boot/grub2/grub.cfg'
[   0.0] Examining the guest ...
[   3.5] Setting a random seed
[   3.6] Running: grub2-mkconfig -o /boot/grub2/grub.cfg
[   4.0] Finishing off
[root@rowan> images]# virt-cat -a /var/lib/libvirt/images/openEuler2403 /boot/grub2/grub.cfg | grep 'net.ifnames=0'
        linux   /vmlinuz-6.6.0-28.0.0.34.oe2403.x86_64 root=UUID=1f4c3ba2-226d-4365-8d1f-30d80117c355 console=tty1 console=ttyS0 rootfstype=ext4 quiet oops=panic softlockup_panic=1 nmi_watchdog=1 rd.shell=0 selinux=0 crashkernel=256M panic=3 net.ifnames=0 
[root@rowan> images]# 





# 1. centos7
kcli create vm -i       centos7 -P memory=4096 -P disks=[50] -P rootpassword=hive -P guestagent=False -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5','noconf':'true'},{'name':'vppdpdk8','noconf':'true'},{'name':'vppdpdk9','noconf':'true'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && yum -y install net-tools pciutils wget lrzsz && wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> ~/.bashrc]' vm

# 2. ubuntu2204
kcli create vm -i    ubuntu2204 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[apt -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' vm

ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.2.96"
ssh 192.168.2.96 "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf ; echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh"
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.96 > /dev/null 2>&1

# 3. ubuntu2404
kcli create vm -i    ubuntu2404 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[apt -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' vm

# 4. ubuntu2410
kcli create vm -i    ubuntu2410 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[apt -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' vm

ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.2.96"
ssh 192.168.2.96 "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf ; echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh"
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.96 > /dev/null 2>&1

# 5. rockylinux9
kcli create vm -i  rockylinux9 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[yum -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' vm
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.2.96"

# 6. rockylinux8
kcli create vm -i  rockylinux8 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[yum -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' vm

# 7. openEuler2403
kcli create vm -i  openEuler2403 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[yum -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' vm

# 8. debian12[bookworm]
kcli create vm -i    vppdebian12    -P memory=10240 -P disks=[70] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P numcpus=9 vm
