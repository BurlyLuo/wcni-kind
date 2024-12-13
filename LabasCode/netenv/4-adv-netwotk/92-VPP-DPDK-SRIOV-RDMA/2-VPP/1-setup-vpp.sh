kcli create vm -i  vm_0_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.127','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" vpp2009



kcli create vm -i  vpp-proto-bookworm -P numcpus=4 -P memory=4096 -P disks=[50] -P nets="[{'name':'brnet'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" vpplcp


