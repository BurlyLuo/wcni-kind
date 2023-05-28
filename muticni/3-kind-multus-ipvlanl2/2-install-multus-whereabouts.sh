#!/bin/bash
set -v
date

# 1. install multus and whereabouts
kubectl apply -f ./multus-cni/deployments/multus-daemonset.yml
kubectl apply -f ./whereabouts/doc/crds/

# 2. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

