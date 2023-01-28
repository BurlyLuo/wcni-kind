#!/bin/bash
kubectl apply -f calico.yaml

KUBERNETES_SERVICE_HOST=`kubectl get nodes --selector=node-role.kubernetes.io/master -o jsonpath='{$.items[*].status.addresses[?(@.type=="InternalIP")].address}'`
cat <<EOF | kubectl apply -f -
kind: ConfigMap
apiVersion: v1
metadata:
  name: kubernetes-services-endpoint
  namespace: kube-system
data:
  KUBERNETES_SERVICE_HOST: "${KUBERNETES_SERVICE_HOST}"
  KUBERNETES_SERVICE_PORT: "6443"

EOF

# restart calico pods
kubectl -nkube-system rollout restart ds/calico-node
kubectl -nkube-system rollout restart deploy/calico-kube-controllers

# enable bpf
calicoctl --allow-version-mismatch patch felixconfiguration default --patch='{"spec": {"bpfEnabled": true}}'

# enable dsr
calicoctl --allow-version-mismatch patch felixconfiguration default --patch='{"spec": {"bpfExternalServiceMode": "DSR"}}'




