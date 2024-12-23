kcli create vm -i    ubuntu2204 -P memory=10240 -P disks=[70] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.96','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P numcpus=10 -P cmds='[apt -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' vm


kcli create vm -i ubuntu2204 -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.66','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" -P cmds='[apt -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' clab

