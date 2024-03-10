#!/bin/bash
set -v
kubectl delete pods macvlan-pod1 macvlan-pod2
sleep 3
kubectl delete net-attach-def macvlan-whereabouts-conf
