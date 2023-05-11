#!/bin/bash

NAME=cluster
NAMESPACE=service-affinity

kubectl --context kind-${NAME}1 create ns $NAMESPACE
kubectl --context kind-${NAME}2 create ns $NAMESPACE
kubectl --context kind-${NAME}1 -n $NAMESPACE apply -f netshoot-ds.yaml
kubectl --context kind-${NAME}2 -n $NAMESPACE apply -f netshoot-ds.yaml
kubectl --context kind-${NAME}1 -n $NAMESPACE apply -f echoserver-service.yaml
kubectl --context kind-${NAME}2 -n $NAMESPACE apply -f echoserver-service.yaml
cilium clustermesh status --context kind-${NAME}1 --wait
cilium clustermesh status --context kind-${NAME}2 --wait


kubectl --context kind-${NAME}1 -n$NAMESPACE get pods -o wide
kubectl --context kind-${NAME}2 -n$NAMESPACE get pods -o wide 
