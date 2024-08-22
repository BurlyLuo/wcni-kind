#!/bin/bash
set -v
kubectl delete pods macvlan-tuning-pod1 macvlan-tuning-pod2
sleep 3
kubectl delete net-attach-def macvlan-whereabouts-tuning-conf
