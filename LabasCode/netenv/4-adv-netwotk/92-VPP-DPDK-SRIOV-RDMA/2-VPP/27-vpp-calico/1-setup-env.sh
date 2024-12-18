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
5. kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
6. kubectl create -f https://raw.githubusercontent.com/projectcalico/vpp-dataplane/v3.29.0/yaml/calico/installation-default.yaml

[root@rowan> LabasCode]# all -o wide 
NAMESPACE              NAME                                       READY   STATUS    RESTARTS      AGE   IP             NODE   NOMINATED NODE   READINESS GATES
calico-apiserver       calico-apiserver-57b79cbdd8-vm8rh          1/1     Running   7 (19h ago)   19h   172.18.74.71   k3s2   <none>           <none>
calico-apiserver       calico-apiserver-57b79cbdd8-zljbf          1/1     Running   8 (74m ago)   19h   172.18.79.30   k3s1   <none>           <none>
calico-system          calico-kube-controllers-7c54f55647-nbfvp   1/1     Running   0             58m   172.18.74.73   k3s2   <none>           <none>
calico-system          calico-node-9wcfs                          1/1     Running   1 (19h ago)   19h   192.168.2.52   k3s2   <none>           <none>
calico-system          calico-node-cwqld                          1/1     Running   3 (63m ago)   19h   192.168.2.51   k3s1   <none>           <none>
calico-system          calico-typha-79d9cfbcff-nlspc              1/1     Running   3 (63m ago)   19h   192.168.2.51   k3s1   <none>           <none>
calico-system          csi-node-driver-2x98j                      2/2     Running   4 (74m ago)   19h   172.18.79.48   k3s1   <none>           <none>
calico-system          csi-node-driver-fbdwg                      2/2     Running   2 (19h ago)   19h   172.18.74.70   k3s2   <none>           <none>
calico-vpp-dataplane   calico-vpp-node-vwsnd                      2/2     Running   0             59m   192.168.2.51   k3s1   <none>           <none>
calico-vpp-dataplane   calico-vpp-node-wtmb8                      2/2     Running   0             59m   192.168.2.52   k3s2   <none>           <none>
default                wluo-b7hrg                                 1/1     Running   1 (19h ago)   19h   172.18.74.69   k3s2   <none>           <none>
default                wluo-zhgfq                                 1/1     Running   2 (74m ago)   19h   172.18.79.33   k3s1   <none>           <none>
kube-system            coredns-77ccd57875-482tr                   1/1     Running   8 (78m ago)   20h   172.18.79.34   k3s1   <none>           <none>
kube-system            local-path-provisioner-957fdf8bc-nb84b     1/1     Running   2 (74m ago)   20h   172.18.79.31   k3s1   <none>           <none>
kube-system            metrics-server-648b5df564-6268p            1/1     Running   9 (75m ago)   20h   172.18.79.32   k3s1   <none>           <none>
tigera-operator        tigera-operator-6489598d75-zm9jj           1/1     Running   0             58m   192.168.2.52   k3s2   <none>           <none>
[root@rowan> LabasCode]# 

