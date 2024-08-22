#!/bin/bash
date
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=cni-multus --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
nodes:
        - role: control-plane
        - role: worker
        - role: worker

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2.remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. install CNI[Calico v3.23.2]
kubectl apply -f ./k8snetworkplumbingwg

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

<<EOF
~ $ ip r s t all
default dev dummy0 table 1002 proto static scope link
default via 10.63.37.169 dev rmnet_data1 table 1015 proto static mtu 1400
10.63.37.168/30 dev rmnet_data1 table 1015 proto static scope link
10.63.37.168/30 dev rmnet_data1 proto kernel scope link src 10.63.37.170
broadcast 10.63.37.168 dev rmnet_data1 table local proto kernel scope link src 10.63.37.170
local 10.63.37.170 dev rmnet_data1 table local proto kernel scope host src 10.63.37.170
broadcast 10.63.37.171 dev rmnet_data1 table local proto kernel scope link src 10.63.37.170
broadcast 127.0.0.0 dev lo table local proto kernel scope link src 127.0.0.1
local 127.0.0.0/8 dev lo table local proto kernel scope host src 127.0.0.1
local 127.0.0.1 dev lo table local proto kernel scope host src 127.0.0.1
broadcast 127.255.255.255 dev lo table local proto kernel scope link src 127.0.0.1
fe80::/64 dev dummy0 table 1002 proto kernel metric 256 pref medium
default dev dummy0 table 1002 proto static metric 1024 pref medium
fe80::/64 dev rmnet_data0 table 1014 proto kernel metric 256 pref medium
2409:8924:4c3d:6af2::/64 dev rmnet_data1 table 1015 proto kernel metric 256 expires 604008sec pref medium
2409:8924:4c3d:6af2::/64 dev rmnet_data1 table 1015 proto static metric 1024 pref medium
fe80::/64 dev rmnet_data1 table 1015 proto kernel metric 256 pref medium
default via fe80::de9:ac39:9ad:b2ba dev rmnet_data1 table 1015 proto ra metric 1024 expires 64744sec hoplimit 255 pref medium
2409:8124:4c3b:7cee::/64 dev rmnet_data2 table 1016 proto kernel metric 256 expires 604007sec pref medium
2409:8124:4c3b:7cee::/64 dev rmnet_data2 table 1016 proto static metric 1024 pref medium
fe80::/64 dev rmnet_data2 table 1016 proto kernel metric 256 pref medium
default via fe80::209f:a6a2:72dd:6fd2 dev rmnet_data2 table 1016 proto ra metric 1024 expires 64743sec hoplimit 255 pref medium
local ::1 dev lo table local proto kernel metric 0 pref medium
local 2409:8124:4c3b:7cee:ac3f:2aff:fea6:b17 dev rmnet_data2 table local proto kernel metric 0 pref medium
local 2409:8924:4c3d:6af2:18bd:ecff:feec:86d7 dev rmnet_data1 table local proto kernel metric 0 pref medium
local fe80::18bd:ecff:feec:86d7 dev rmnet_data1 table local proto kernel metric 0 pref medium
local fe80::84b6:1ff:fe3d:591a dev rmnet_data0 table local proto kernel metric 0 pref medium
local fe80::8c20:88ff:fe05:e220 dev dummy0 table local proto kernel metric 0 pref medium
local fe80::ac3f:2aff:fea6:b17 dev rmnet_data2 table local proto kernel metric 0 pref medium
multicast ff00::/8 dev dummy0 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev rmnet_data0 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev rmnet_data2 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev rmnet_data1 table local proto kernel metric 256 pref medium
~ $ ip rule show
0:      from all lookup local
10000:  from all fwmark 0xc0000/0xd0000 lookup 99
11000:  from all iif lo oif dummy0 uidrange 0-0 lookup 1002
11000:  from all iif lo oif rmnet_data0 uidrange 0-0 lookup 1014
11000:  from all iif lo oif rmnet_data2 uidrange 0-0 lookup 1016
11000:  from all iif lo oif rmnet_data1 uidrange 0-0 lookup 1015
16000:  from all fwmark 0x10063/0x1ffff iif lo lookup 97
16000:  from all fwmark 0xd0001/0xdffff iif lo lookup 1014
16000:  from all fwmark 0xd00b2/0xdffff iif lo lookup 1016
16000:  from all fwmark 0x100b3/0x1ffff iif lo lookup 1015
17000:  from all iif lo oif dummy0 lookup 1002
17000:  from all fwmark 0xc0000/0xc0000 iif lo oif rmnet_data0 lookup 1014
17000:  from all fwmark 0xc0000/0xc0000 iif lo oif rmnet_data2 lookup 1016
17000:  from all iif lo oif rmnet_data1 lookup 1015
18000:  from all fwmark 0/0x10000 lookup 99
19000:  from all fwmark 0/0x10000 lookup 98
20000:  from all fwmark 0/0x10000 lookup 97
23000:  from all fwmark 0xb3/0x1ffff iif lo lookup 1015
29000:  from all lookup default
29000:  from all fwmark 0/0xffff iif lo lookup 1015
31000:  from all lookup main
32000:  from all unreachable
~ $
EOF
