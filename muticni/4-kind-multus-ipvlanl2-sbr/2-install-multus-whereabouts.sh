#!/bin/bash
set -v
date

kubectl apply -f ./multus-cni/deployments/multus-daemonset.yml

kubectl apply -f ./whereabouts/doc/crds/

kubectl get nodes -o wide

kubectl get pods -o wide -A

