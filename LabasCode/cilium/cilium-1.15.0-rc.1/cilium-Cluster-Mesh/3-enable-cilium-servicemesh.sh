#!/bin/bash
set -v
cilium clustermesh enable --context kind-cluster1 --service-type NodePort
cilium clustermesh enable --context kind-cluster2 --service-type NodePort

cilium clustermesh connect --context kind-cluster1 --destination-context kind-cluster2

kubectl --context=kind-cluster1 wait --timeout=100s --for=condition=Ready=true pods --all -A --field-selector=status.phase!=Succeeded
kubectl --context=kind-cluster2 wait --timeout=100s --for=condition=Ready=true pods --all -A --field-selector=status.phase!=Succeeded
cilium clustermesh status  --context kind-cluster1 --wait
