#!/bin/bash
set -v 
kubectl delete pods ipvlanl3-pod1 ipvlanl3-pod2
kubectl delete net-attach-def ipvlanl3-whereabouts-conf-1 ipvlanl3-whereabouts-conf-2
