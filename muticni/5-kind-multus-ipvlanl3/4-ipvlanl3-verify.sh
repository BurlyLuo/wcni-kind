#!/bin/bash
set -v 
kubectl exec -it ipvlanl3-pod1 -- ip r a 15.1.2.0/24 dev eth1
kubectl exec -it ipvlanl3-pod2 -- ip r a 15.1.1.0/24 dev eth1

kubectl exec -it ipvlanl3-pod1 -- ping 15.1.2.20

