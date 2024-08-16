# 0.env perp:
virt-install --name vpp1 --memory 10240  --cpu host-model --vcpus=8 --disk /root/kvm/vpp1.qcow2,device=disk,bus=virtio --disk size=30 --os-variant centos7.0 --virt-type kvm --graphics none --network=bridge=brnet,model=virtio --network=bridge=vppdpdk5,model=virtio --network=bridge=vppdpdk8,model=virtio --import
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@192.168.2.98 > /dev/null 2>&1
master_ip=192.168.2.98
k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=vpp
kubectl create -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml [sed -i "s#10.244#10.42#g" kube-flannel.yml]

# 1.hugepage and cpu isolution:
vi /etc/default/grub 
GRUB_CMDLINE_LINUX="console=tty0 crashkernel=auto net.ifnames=0 console=ttyS0 isolcpus=1,2,3 iommu=pt intel_iommu=on default_hugepagesz=1G hugepagesz=1G hugepages=2"
grub2-mkconfig -o /boot/grub2/grub.cfg && reboot

if abnormal with hugepage, pls mode the hugepage, and restart k3s[systemctl restart k3s]
[root@localhost hugepages-1048576kB]# pwd
/sys/devices/system/node/node0/hugepages/hugepages-1048576kB
[root@localhost hugepages-1048576kB]# ll
-r--r--r--. 1 root root 4096 Jan  7 05:27 free_hugepages
-rw-r--r--. 1 root root 4096 Jan  7 05:27 nr_hugepages [echo 2 > nr_hugepages] [systemctl restart k3s]
-r--r--r--. 1 root root 4096 Jan  7 05:27 surplus_hugepages
[root@localhost hugepages-1048576kB]# 
#[outputs:]
[Capacity:
  cpu:                       8
  ephemeral-storage:         52416384Ki
  hugepages-1Gi:             2Gi   
  intel.com/sriov_vppdpdk5:  1
  intel.com/sriov_vppdpdk8:  1
  memory:                    10072208Ki
  pods:                      110
Allocatable:
  cpu:                       8
  ephemeral-storage:         50990658316
  hugepages-1Gi:             2Gi
  intel.com/sriov_vppdpdk5:  1
  intel.com/sriov_vppdpdk8:  1
  memory:                    7975056Ki
  pods:                      110]

# 2.multus mutiple nics:
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml

# 3.sriov-dpdk resource
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/sriov-network-device-plugin/master/deployments/sriovdp-daemonset.yaml
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/sriov-cni/master/images/sriov-cni-daemonset.yaml
ip l s eth1 down && ip l s eth2 down
lshw -class network -businfo
modprobe vfio_pci
echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode
./dpdk.py --bind=vfio-pci 0000:02:00.0
./dpdk.py --bind=vfio-pci 0000:03:00.0

# vpp.yaml
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

#[outputs]
Capacity:
  cpu:                       8
  ephemeral-storage:         52416384Ki
  hugepages-1Gi:             2Gi
  intel.com/sriov_vppdpdk5:  1
  intel.com/sriov_vppdpdk8:  1
  memory:                    10072208Ki
  pods:                      110
Allocatable:
  cpu:                       8
  ephemeral-storage:         50990658316
  hugepages-1Gi:             2Gi
  intel.com/sriov_vppdpdk5:  1
  intel.com/sriov_vppdpdk8:  1
  memory:                    7975056Ki
  pods:                      110

# 4.whereabouts IPAM
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/whereabouts/master/doc/crds/daemonset-install.yaml
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/whereabouts/master/doc/crds/whereabouts.cni.cncf.io_ippools.yaml
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/whereabouts/master/doc/crds/whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
#[All mutiple nics:]
[root@localhost ~]# kubectl get pods -owide -A
NAMESPACE      NAME                                     READY   STATUS    RESTARTS       AGE     IP             NODE        NOMINATED NODE   READINESS GATES
kube-flannel   kube-flannel-ds-8n5nf                    1/1     Running   17 (20h ago)   2d19h   192.168.2.98   localhost   <none>           <none>
kube-system    coredns-77ccd57875-25zzx                 1/1     Running   10 (20h ago)   2d19h   10.42.0.50     localhost   <none>           <none>
kube-system    kube-multus-ds-jnkgd                     1/1     Running   4 (20h ago)    2d18h   192.168.2.98   localhost   <none>           <none>
kube-system    kube-sriov-cni-ds-amd64-bbndx            1/1     Running   10 (20h ago)   2d19h   10.42.0.49     localhost   <none>           <none>
kube-system    kube-sriov-device-plugin-amd64-wwtbz     1/1     Running   4 (20h ago)    2d18h   192.168.2.98   localhost   <none>           <none>
kube-system    local-path-provisioner-957fdf8bc-b7wh8   1/1     Running   16 (20h ago)   2d19h   10.42.0.47     localhost   <none>           <none>
kube-system    metrics-server-648b5df564-dn2pd          1/1     Running   15 (20h ago)   2d19h   10.42.0.48     localhost   <none>           <none>
kube-system    whereabouts-dxmp9                        1/1     Running   12 (20h ago)   2d19h   192.168.2.98   localhost   <none>           <none>
[root@localhost ~]# 

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
    image: soelvkaer/vppcontainer:latest
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: hugepage
      mountPath: /hugepages
    - name: vppconfig
      mountPath: /etc/vpp/
    - name: startupconfig
      mountPath: /root/
    #command: [ "/sbin/init" ]
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
  - name: vppconfig
    configMap:
      name: vppconfig
  - name: startupconfig
    configMap:
      name: startupconfig
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: vppconfig
data:
  startup.conf: |
    unix {
      nodaemon
      log /var/log/vpp/vpp.log
      full-coredump
      cli-listen /run/vpp/cli.sock
      gid vpp
      startup-config /root/startupconfig
    }
    api-trace {
      on
    }
    api-segment {
      gid vpp
    }
    cpu { 
        main-core 0
        corelist-workers 1,2
    }
    dpdk {
      dev 0000:02:00.0 {
          name fpeth1
      }
      dev 0000:03:00.0 {
          name fpeth2
    }
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: startupconfig
data:
  startupconfig: |
    set interface ip address fpeth1 10.1.5.10/24
    set interface state fpeth1 up
    set interface ip address fpeth2 10.1.8.10/24
    set interface state fpeth2 up
    ip route add 0.0.0.0/0 via 10.1.5.254 fpeth1
EOF

[if with centos/tools, need install vpp manually.]
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

# Enable CPU policy
rm -rf /var/lib/kubelet/cpu_manager_state 

cat /var/lib/kubelet/kubeadm-flags.env  //Add ：--cpu-manager-policy=static --kube-reserved=cpu=1(reserve 1 cpu for host.)。
KUBELET_KUBEADM_ARGS="--network-plugin=cni --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.6 --cpu-manager-policy=static --kube-reserved=cpu=1"

# Enable CPU pin with tuna:
[root@rocky92 ~]# systemctl cat cpu-pinning 
# /usr/lib/systemd/system/cpu-pinning.service
[Unit]
Description=CPU pinning configuration
Before=basic.target
After=local-fs.target sysinit.target
DefaultDependencies=no
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/home/mav/cpu-pin/cpu-pinning.sh
[Install]
WantedBy=sysinit.target
[root@rocky92 ~]# cat /home/mav/cpu-pin/cpu-pinning.sh
#!/bin/bash
export LC_ALL="en_US.UTF-8"
systemctl stop irqbalance; systemctl disable irqbalance
tuna isolate --cpus=4-7
tuna spread --irqs='*' --cpus=0-3
[root@rocky92 ~]#


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

cpu {
    main-core 0
    corelist-workers 1,2,3
}

dpdk {
  dev 0000:02:00.0 {
      name fpeth1  
      num-rx-queues 3
      num-tx-queues 4
      num-rx-desc 1024
      num-tx-desc 1024
  }
  dev 0000:03:00.0 {
      name fpeth2
      num-rx-queues 3
      num-tx-queues 4
      num-rx-desc 1024
      num-tx-desc 1024
  }
}
}


# cat /etc/vpp/exec 
set interface ip address GigabitEthernet2/0/0 10.1.5.10/24
set interface state GigabitEthernet2/0/0 up
set interface ip address GigabitEthernet3/0/0 10.1.8.10/24
set interface state GigabitEthernet3/0/0 up
ip route add 0.0.0.0/0 via 10.1.5.254 fpeth1

systemctl start vpp && systemctl enable vpp
or
# CMD ["/usr/bin/vpp", "-c", "/etc/vpp/startup.conf"]
/usr/bin/vpp -c /etc/vpp/startup.conf & 


# Docekrfile:
FROM ubuntu:18.04

ENV VPP_VER "20.01"

RUN apt-get update && apt-get --no-install-recommends install -y \
    gnupg \
    apt-transport-https \
    curl \
    ca-certificates

RUN curl -s https://packagecloud.io/install/repositories/fdio/release/script.deb.sh | bash

RUN apt-get --no-install-recommends install -y \
    dpdk \
    vpp=${VPP_VER}-release \
    vpp-plugin-core=${VPP_VER}-release \
    vpp-plugin-dpdk=${VPP_VER}-release \
    libvppinfra=${VPP_VER}-release

CMD ["/usr/bin/vpp", "-c", "/etc/vpp/startup.conf"]


# env:
[root@localhost ~]# kubectl exec -it vpp bash 
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
eroot@vpp:/# env
HOSTNAME=vpp
PCIDEVICE_INTEL_COM_SRIOV_VPPDPDK5_INFO={"0000:02:00.0":{"generic":{"deviceID":"0000:02:00.0"},"vfio":{"dev-mount":"/dev/vfio/0","mount":"/dev/vfio/vfio"}}}
VPP_VER=20.01
PCIDEVICE_INTEL_COM_SRIOV_VPPDPDK5=0000:02:00.0
PCIDEVICE_INTEL_COM_SRIOV_VPPDPDK8=0000:03:00.0
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.43.0.1
PCIDEVICE_INTEL_COM_SRIOV_VPPDPDK8_INFO={"0000:03:00.0":{"generic":{"deviceID":"0000:03:00.0"},"vfio":{"dev-mount":"/dev/vfio/1","mount":"/dev/vfio/vfio"}}}
KUBERNETES_PORT=tcp://10.43.0.1:443
PWD=/
HOME=/root
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.43.0.1:443
TERM=xterm
SHLVL=1
KUBERNETES_SERVICE_PORT=443
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_SERVICE_HOST=10.43.0.1
_=/usr/bin/env
root@vpp:/# 
