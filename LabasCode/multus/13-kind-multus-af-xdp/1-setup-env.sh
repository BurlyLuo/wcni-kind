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
          extraMounts:
            - hostPath: /tmp/afxdp_dp/
              containerPath: /tmp/afxdp_dp/
              propagation: Bidirectional
              selinuxRelabel: false
        - role: worker
          extraMounts:
            - hostPath: /tmp/afxdp_dp2/
              containerPath: /tmp/afxdp_dp/
              propagation: Bidirectional
              selinuxRelabel: false

containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2.remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide
kubectl label node cni-multus-worker cndp="true"
kubectl label node cni-multus-worker2 cndp="true"

./2-setup-clab.sh

for i in $(docker ps --format '{{.Names}}'| grep cni-multus- | grep -v clab);do docker exec -it $i bash -c "sysctl kernel.unprivileged_bpf_disabled=0";done

# 3. install CNI[Calico v3.23.2]
kubectl apply -f ./k8snetworkplumbingwg

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

