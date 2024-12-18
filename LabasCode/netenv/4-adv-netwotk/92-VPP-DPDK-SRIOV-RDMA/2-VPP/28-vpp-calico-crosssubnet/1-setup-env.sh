kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'vppdpdk5','ip':'10.1.5.51','netmask':'24','gateway':'10.1.5.3'}]" k1
kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'vppdpdk8','ip':'10.1.8.52','netmask':'24','gateway':'10.1.8.3'}]" k2


