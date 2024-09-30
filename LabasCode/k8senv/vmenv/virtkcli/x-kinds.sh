# kcli render -f ./all_parameters.yml -c

# 1. centos7
kcli create vm -i       centos7 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && yum -y install net-tools pciutils wget lrzsz && wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth]' vm

# 2. centos8stream
# https://github.com/karmab/kcli/issues/723
kcli create vm -i centos8stream -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[rm -rf /etc/yum.repos.d/* && pkill yum ; curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo ; pkill yum && yum -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth]' vm

# 3. centos9stream
kcli create vm -i centos9stream -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='["yum -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm

# 4. ubuntu2204
kcli create vm -i    ubuntu2204 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='[apt -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm
ssh 192.168.2.96 "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf ; echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh"
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.96 > /dev/null 2>&1

# 5. debian12
kcli create vm -i      debian12 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='["apt -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm
ssh 192.168.2.96 "sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf ; echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh"
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.96 > /dev/null 2>&1

# 6. rockylinux9
kcli create vm -i  rockylinux9 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P cpupinning=['{"vcpus": "0", "hostcpus": "0"}','{"vcpus": "1", "hostcpus": "1"}','{"vcpus": "2", "hostcpus": "2"}','{"vcpus": 3, "hostcpus": 3}'] -P numcpus=4 -P cmds='["yum -y install net-tools pciutils wget lrzsz" , "wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth"]' vm

