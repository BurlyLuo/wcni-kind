kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.51','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" k3s1

kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.52','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" k3s2

# addk3svm to setup a multi-node k3s cluster.
addk3svm

# delk3svm to destroy a multi-node k3s cluster.
delk3svm

1. how to install the vpp based calico
   https://github.com/projectcalico/vpp-dataplane/issues/222
1. https://docs.tigera.io/calico/latest/operations/troubleshoot/troubleshooting#configure-networkmanager
2. kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml
3. curl -o calico-vpp.yaml https://raw.githubusercontent.com/projectcalico/vpp-dataplane/v3.29.0/yaml/generated/calico-vpp-nohuge.yaml  # replace the "interfaceName": "eth0" with default route interface name
4. kubectl create -f calico-vpp.yaml

