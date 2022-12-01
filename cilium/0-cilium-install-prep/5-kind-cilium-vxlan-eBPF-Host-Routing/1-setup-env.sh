#!/bin/bash
date
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=cilium-vxlan-host-routing --image=kindest/node:v1.23.4 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
        kubeProxyMode: "none"
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
controller_node=`kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane`
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-
kubectl get nodes -o wide

# 3. install CNI
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node --set k8sServicePort=6443 --version 1.12.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-vxlan-host-routing --set kubeProxyReplacement=strict --set bpf.masquerade=true

# 4. install necessary tools
for i in $(docker ps  -a --format "table {{.Names}}" | grep cilium-vxlan-host-routing)
do 
    echo $i
    docker cp /usr/bin/cilium $i:/usr/bin/cilium
    docker cp /usr/bin/ping $i:/usr/bin/ping
    docker exec -it $i bash -c "sed -i -e 's/jp.archive.ubuntu.com\|archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list"
    docker exec -it $i bash -c "apt-get -y update >/dev/null && apt-get -y install net-tools tcpdump lrzsz >/dev/null"
done

