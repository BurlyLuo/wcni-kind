# 1. centos9stream
kcli create vm -i centos9stream -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='["yum -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm

# 2. ubuntu2204
kcli create vm -i   ubuntu2204 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='["apt -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm
ssh 192.168.2.96 "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf ; echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh"
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.96 > /dev/null 2>&1

# 3. debian12
kcli create vm -i     debian12 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='["apt -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm
ssh 192.168.2.96 "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf ; echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh"
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.96 > /dev/null 2>&1

# 4. rocky9
kcli create vm -i  rockylinux9 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='["yum -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm
