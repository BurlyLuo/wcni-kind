#!/bin/bash
date
set -v

kind create cluster --name=calico-vpp --config=./kind-calico.yaml --image=kindest/node:v1.23.4

controller_node=$(kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane)
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-

for i in $(docker ps  -a --format "table {{.Names}}"|grep calico-vpp );do echo $i;docker cp /usr/bin/calicoctl $i:/usr/bin/calicoctl;docker cp /usr/bin/ping $i:/usr/bin/ping;docker exec -it $i  bash -c "sed -i -e 's/jp.archive.ubuntu.com\|archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list";docker exec -it $i bash -c "apt-get -y update >/dev/null && apt-get -y install net-tools tcpdump >/dev/null";done

