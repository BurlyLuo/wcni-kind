#!/bin/bash
controller_node=$(kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name| grep control-plane)
kubectl taint nodes $controller_node node-role.kubernetes.io/master:NoSchedule-

for node in $(kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name);do echo $node;docker cp ./bridge $node:/opt/cni/bin/;docker cp /usr/bin/ping $node:/usr/bin/ping;docker exec -it $node  bash -c "sed -i -e 's/jp.archive.ubuntu.com\|archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list";done
