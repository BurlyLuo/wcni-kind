#!/bin/bash

set -v

kind create cluster --name=flannel-udp --config=./kind-flannel.yaml --image=kindest/node:v1.23.4

controller_node=$(kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane)
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-

kubectl apply -f ./flannel.yaml

for i in $(docker ps  -a --format "table {{.Names}}"|grep flannel-udp );do echo $i;docker cp ./bridge $i:/opt/cni/bin/;docker cp /usr/bin/ping $i:/usr/bin/ping;docker exec -it $i  bash -c "sed -i -e 's/jp.archive.ubuntu.com\|archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list";docker exec -it $i bash -c "apt-get -y update >/dev/null && apt-get -y install net-tools tcpdump lrzsz >/dev/null";done

