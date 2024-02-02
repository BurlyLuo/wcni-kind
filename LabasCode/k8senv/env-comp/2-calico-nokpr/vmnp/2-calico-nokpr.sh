#!/bin/bash
date
set -v
# 1. install calcio cni
kubectl apply -f ./calico.yaml

# 2. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

