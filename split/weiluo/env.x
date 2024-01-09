1. Workhome env
$ uname -r 
6.2.0-31-generic
$ lsb_release -a 
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.2 LTS
Release:        22.04
Codename:       jammy


2. kindest/node image
docker pull burlyluo/kindest:v1.27.3
or
docker pull quay.io/weiluo/kindest/node:v1.27.3

3. nettool image
docker pull burlyluo/nettool:latest
or
docker pull quay.io/weiluo/nettool

4. vyos image
docker pull burlyluo/vyos:1.4.7
or 
docker pull quay.io/weiluo/vyos:1.4.7

5. if install docker. the FORWARD will be set -j DROP. and the basical test will failure.
Like eth0--ns1--bridge[br0]--ns2--eth2 

root@2204:~/wcni-kind/split# multipass version 
multipass   1.12.2
multipassd  1.12.2
root@2204:~/wcni-kind/split# 

root@2204:~/wcni-kind/split/weiluo# kind version 
kind v0.20.0 go1.20.4 linux/amd64
root@2204:~/wcni-kind/split/weiluo# 

root@2204:~/wcni-kind/split/weiluo# clab version 

                           _                   _       _     
                 _        (_)                 | |     | |    
 ____ ___  ____ | |_  ____ _ ____   ____  ____| | ____| | _  
/ ___) _ \|  _ \|  _)/ _  | |  _ \ / _  )/ ___) |/ _  | || \ 
( (__| |_|| | | | |_( ( | | | | | ( (/ /| |   | ( ( | | |_) )
\____)___/|_| |_|\___)_||_|_|_| |_|\____)_|   |_|\_||_|____/ 

    version: 0.42.0
     commit: 27689089
       date: 2023-06-17T12:45:12Z
     source: https://github.com/srl-labs/containerlab
 rel. notes: https://containerlab.dev/rn/0.42/


6. Cilium clustermesh deploy muti-cluster faliure:
cat <<EOF>>/etc/sysctl.conf
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
EOF
sysctl -p



7. DinD:
 docker run \
        --hostname wluo-control-plane \
        --name wluo-control-plane \
        --label io.x-k8s.kind.role=control-plane \
        --privileged \
        --security-opt seccomp=unconfined \
        --rm \
        --tmpfs /tmp \
        --tmpfs /run \
        --volume /var \
        --volume /lib/modules:/lib/modules:ro \
        --detach \
        --tty \
        --label io.x-k8s.kind.cluster=crossplane \
        --publish=80:80/TCP \
        --publish=443:443/TCP \
        --publish=127.0.0.1:0:6443/TCP \
        192.168.2.100:5000/kindest/node:v1.27.3


#!/bin/bash
img=$(docker images --format {{.Repository}}:{{.Tag}})
for i in ${img}
do        
if [ -n "$(docker ps -q --filter ancestor=${i})" ] ;then                
  echo "running Docker:${i}"
else
  echo "not runnig Docker:${i}"
  docker rmi ${i}
fi
done

8. vpp+dpdk
lshw -class network -businfo
for intf in  eth1 eth2 eth3; do
  for pci_id in `ls -l /sys/class/net/$intf/device/virtfn* | cut -d '/' -f8`; do
      echo $intf $pci_id
  done
done

9. k8s
while true;do ns=ns1;unit_sts_name=sts-unit;if [[ $(kubectl -n$ns get statefulset $unit_sts_name -o jsonpath='{.status.readyReplicas}') -eq $(kubectl -n$ns get statefulset $unit_sts_name -o jsonpath='{.spec.replicas}') ]]; then break;else sleep 1;fi;done

until controller_node_ip=$(kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}');[ -n "$controller_node_ip" ];do sleep 1;done
until pod_list=$(kubectl get pods -o wide -A --no-headers);[ -n "$pod_list" ];do sleep 1;done

kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
kubectl -nkube-system wait --timeout=60s --for=condition=Ready=true pod -l k8s-app=calico-node

