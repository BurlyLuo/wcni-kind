#!/bin/bash
set -x

kind create  cluster --name=kind-ha --config=./kind-ha.yaml --image=kindest/node:v1.23.4

sleep 30

kubectl apply -f ./calico.yaml
