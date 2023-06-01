#!/bin/bash
set -v 

# 1. install CNI[Calico v3.23.2]
kubectl apply -f calico.yaml

# 2. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

