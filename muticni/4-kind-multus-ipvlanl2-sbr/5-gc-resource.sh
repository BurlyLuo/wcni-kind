#!/bin/bash
set -v 
kubectl delete pods ipvlan-pod-sbr
kubectl delete net-attach-def ipvlanl2-whereabouts-conf
