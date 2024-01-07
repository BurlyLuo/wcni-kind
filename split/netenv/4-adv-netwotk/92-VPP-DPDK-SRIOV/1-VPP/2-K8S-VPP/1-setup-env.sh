# 0.env perp:
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.98 > /dev/null 2>&1
master_ip=192.168.2.98
k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=vpp
kubectl create -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml [sed -i "s#10.244#10.42#g" kube-flannel.yml]

# 1.hugepage and cpu isolution:
vi /etc/default/grub 
GRUB_CMDLINE_LINUX="console=tty0 crashkernel=auto net.ifnames=0 console=ttyS0 isolcpus=1,2,3  default_hugepagesz=1G hugepagesz=1G hugepages=2"
grub2-mkconfig -o /boot/grub2/grub.cfg && reboot
if abnormal with hugepage, pls mode the hugepage, and restart k3s
[root@localhost hugepages-1048576kB]# pwd
/sys/devices/system/node/node0/hugepages/hugepages-1048576kB
[root@localhost hugepages-1048576kB]# ll
total 0
-r--r--r--. 1 root root 4096 Jan  7 05:27 free_hugepages
-rw-r--r--. 1 root root 4096 Jan  7 05:27 nr_hugepages
-r--r--r--. 1 root root 4096 Jan  7 05:27 surplus_hugepages
[root@localhost hugepages-1048576kB]# 

# 2.multus mutiple nics:
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml
 
# 3.sriov-dpdk resource
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/sriov-network-device-plugin/master/deployments/sriovdp-daemonset.yaml
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/sriov-cni/master/images/sriov-cni-daemonset.yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: sriovdp-config
  namespace: kube-system
data:
  config.json: |
    {
        "resourceList": [
            {
                "resourceName": "sriov_vppdpdk5",
                "selectors":
                {
                    "drivers": ["vfio-pci"],
                    "pciaddresses": ["0000:02:00.0"]
                }
            },
            {
                "resourceName": "sriov_vppdpdk8",
                "selectors":
                {
                    "drivers": ["vfio-pci"],
                    "pciaddresses": ["0000:03:00.0"]
                }
            }
        ]
    }
EOF

# 4.whereabouts IPAM
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/whereabouts/master/doc/crds/daemonset-install.yaml
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/whereabouts/master/doc/crds/whereabouts.cni.cncf.io_ippools.yaml
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/whereabouts/master/doc/crds/whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml

# 5.vpp.yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: vpp
  #annotations:
  #  k8s.v1.cni.cncf.io/networks: sriov-net1
spec:
  containers:
  - name: vpp
    image: centos/tools 
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: hugepage
      mountPath: /hugepages
    command: [ "/sbin/init" ]
    #command: [ "/bin/bash", "-c", "--" ]
    #args: [ "while true; do sleep 300000; done;" ]
    securityContext:
      privileged: true
    resources:
      requests:
        cpu: 4
        memory: 2G
        hugepages-1Gi: 2Gi
        intel.com/sriov_vppdpdk5: '1'
        intel.com/sriov_vppdpdk8: '1'
      limits:
        cpu: 4
        memory: 2G
        hugepages-1Gi: 2Gi
        intel.com/sriov_vppdpdk5: '1'
        intel.com/sriov_vppdpdk8: '1'
  volumes:
  - name: hugepage
    emptyDir:
      medium: HugePages
EOF

#6. install vpp at vpp_pod
# kubectl exec -it vpp bash
yum -y install epel-release && yum list && yum update -y
yum install -y epel-release mbedtls python36
cat <<EOF>/etc/yum.repos.d/fdio-release.repo
[fdio_release]
name=fdio_release
baseurl=https://packagecloud.io/fdio/release/el/7/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/fdio/release/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF


ip l s eth1 down && ip l s eth2 down 
lshw -class network -businfo
modprobe vfio_pci
echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode
./dpdk.py --bind=vfio-pci eth1
./dpdk.py --bind=vfio-pci eth2


yum -q makecache -y --disablerepo='*' --enablerepo='fdio_release'
yum list vpp* && yum install -y vpp vpp-api-lua vpp-api-python vpp-api-python3 vpp-debuginfo vpp-devel vpp-ext-deps vpp-lib vpp-plugins vpp-selinux-policy
# vi /etc/vpp/startup.conf
unix {
  nodaemon
  log /var/log/vpp/vpp.log
  full-coredump
  cli-listen /run/vpp/cli.sock
  exec /etc/vpp/exec
  gid vpp
}

# cat /etc/vpp/exec 
set interface ip address GigabitEthernet2/0/0 10.1.5.10/24
set interface state GigabitEthernet2/0/0 up
set interface ip address GigabitEthernet3/0/0 10.1.8.10/24
set interface state GigabitEthernet3/0/0 up

systemctl start vpp && systemctl enable vpp

