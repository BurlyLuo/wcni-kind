#!/bin/bash
set -v
date

# create registry container unless it already exists
reg_name='kind-registry'
reg_port='5000'
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  docker run -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" registry:2
fi

# create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster --name=calico-bgp --image=kindest/node:v1.25.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
        disableDefaultCNI: true
nodes:
        - role: control-plane
        - role: worker


containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${reg_port}"]
    endpoint = ["http://${reg_name}:5000"]
EOF

# connect the registry to the cluster network if not already connected
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${reg_name}")" = 'null' ]; then
  docker network connect "kind" "${reg_name}"
fi

# Document the local registry
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${reg_port}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF

# prep the environment
controller_node=$(kubectl get nodes --no-headers  -o custom-columns=NAME:.metadata.name | grep control-plane)
kubectl taint nodes $controller_node node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -owide 

# install CNI [[https://github.com/projectcalico/calico/releases/tag/v3.23.3]]
kubectl apply -f ./calico.yaml

# prep the necessary tools
for i in $(docker ps  -a --format "table {{.Names}}" | grep calico-bgp);
do 
echo $i;
docker cp /usr/bin/calicoctl $i:/usr/bin/calicoctl;
docker cp /usr/bin/ping $i:/usr/bin/ping;
docker exec -it $i bash -c "apt-get -y update >/dev/null && apt-get -y install net-tools tcpdump lrzsz vim wget >/dev/null";
done

# deploy test pods
kubectl apply -f cni.yaml

