#!/bin/bash
set -v 
kubectl delete pods ipvlan-pod-x ipvlan-pod1 ipvlan-pod2
sleep 3
kubectl delete net-attach-def ipvlanl2-whereabouts-conf
