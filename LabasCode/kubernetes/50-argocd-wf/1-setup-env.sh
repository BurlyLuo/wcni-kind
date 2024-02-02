#!/bin/bash
set -v

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=calico-bgp-fullmesh --image=kindest/node:v1.27.3 --config=-
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
kubectl apply -f http://192.168.2.100/http/cni/calico.yaml

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. deploy argocd and argowf
kubectl create ns argocd && kubectl -nargocd apply -f install-argocd.yaml

kubectl create ns argo && kubectl -nargo apply -f install-argowf.yaml
kubectl patch deployment \
	  argo-server \
	    --namespace argo \
	      --type='json' \
	        -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
  "server",
    "--auth-mode=server"
    ]}]'

