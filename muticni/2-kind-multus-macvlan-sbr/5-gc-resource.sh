#!/bin/bash
set -v
kubectl delete pods macvlan-sbr-pod1 macvlan-sbr-pod2
kubectl delete net-attach-def macvlan-whereabouts-conf
