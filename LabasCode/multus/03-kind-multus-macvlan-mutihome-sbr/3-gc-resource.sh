#!/bin/bash
set -v
kubectl delete pods multihoming-pod1 multihoming-pod2
sleep 3
kubectl delete net-attach-def multihoming-sbr-conf1 multihoming-sbr-conf2
