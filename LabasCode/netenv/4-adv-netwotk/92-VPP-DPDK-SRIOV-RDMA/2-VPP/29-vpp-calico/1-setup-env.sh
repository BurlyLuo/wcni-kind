kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.51','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" k3s1

kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.52','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" k3s2

