#!/bin/bash

set -v

ip r d 2.2.2.2 > /dev/null 2>&1

clang -O2 -Wall -target bpf -c bpf_xdp_veth_host.c -o bpf_xdp_veth_host.o
clang -O2 -Wall -target bpf -c test_tc_tunnel.c -o test_tc_tunnel.o

# 1. prep env:
cat <<EOF | kind create cluster --image=192.168.2.100:5000/kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  kubeProxyMode: "none"

nodes:
  - role: control-plane # L4LB (kind-control-plane)
  - role: worker        # client (kind-worker)
  - role: worker        # nginx backend (kind-worker2)
  - role: worker        # nginx backend (kind-worker3)
        
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

kubectl apply -f cilium-lb.yaml

# 2. Set LB_IP
IFIDX=$(docker exec -i kind-control-plane \
    /bin/sh -c 'echo $(( $(ip -o l show eth0 | awk "{print $1}" | cut -d: -f1) ))')
echo "IFIDX": $IFIDX

LB_VETH_HOST=$(ip -o l | grep "if$IFIDX" | awk '{print $2}' | cut -d@ -f1)
echo "LB_VETH_HOST": $LB_VETH_HOST

ip l set dev $LB_VETH_HOST xdp obj bpf_xdp_veth_host.o

ethtool -K $LB_VETH_HOST rx off tx off

LB_IP=$(docker exec -ti kind-control-plane ip -o -4 a s eth0 | awk '{print $4}' | cut -d/ -f1 | grep 172.18.0.)
echo "LB_IP": $LB_IP

# 3. kind-worker2 node
docker exec -ti kind-worker2 /bin/sh -c \
'apt-get update && apt-get install -y nginx && echo Current_Backend_Host: $(hostname) > /var/www/html/index.nginx-debian.html && systemctl start nginx'

WORKER2_IP=$(docker exec -ti kind-worker2 ip -o -4 a s eth0 | awk '{print $4}' | cut -d/ -f1 | grep 172.18.0.)
echo "WORKER2_IP": $WORKER2_IP

nsenter -t $(docker inspect kind-worker2 -f '{{ .State.Pid }}') -n /bin/sh -c \
    'tc qdisc add dev eth0 clsact && tc filter add dev eth0 ingress bpf direct-action object-file ./test_tc_tunnel.o section decap && ip a a dev eth0 2.2.2.2/32'

# 4. kind-worker3 node
docker exec -ti kind-worker3 /bin/sh -c \
'apt-get update && apt-get install -y nginx && echo Current_Backend_Host: $(hostname) > /var/www/html/index.nginx-debian.html && systemctl start nginx'

WORKER3_IP=$(docker exec -ti kind-worker3 ip -o -4 a s eth0 | awk '{print $4}' | cut -d/ -f1 | grep 172.18.0.)
echo "WORKER3_IP": $WORKER2_IP

nsenter -t $(docker inspect kind-worker3 -f '{{ .State.Pid }}') -n /bin/sh -c \
    'tc qdisc add dev eth0 clsact && tc filter add dev eth0 ingress bpf direct-action object-file ./test_tc_tunnel.o section decap && ip a a dev eth0 2.2.2.2/32'

# 5. update service backend
CILIUM_POD_NAME=$(kubectl -nkube-system get pods --no-headers --selector=k8s-app=cilium -owide --field-selector spec.nodeName=kind-control-plane|awk -F " " '{print $1}')
kubectl -n kube-system wait --timeout=300s --for=condition=Ready pod "$CILIUM_POD_NAME"

kubectl -n kube-system exec -ti $CILIUM_POD_NAME -- \
    cilium service update --id 1 --frontend "2.2.2.2:80" --backends "${WORKER2_IP}:80","${WORKER3_IP}:80" --k8s-node-port

# 6. make a test
ip r a 2.2.2.2/32 via "$LB_IP"

for i in $(seq 1 10); do
    curl "2.2.2.2:80"
done
