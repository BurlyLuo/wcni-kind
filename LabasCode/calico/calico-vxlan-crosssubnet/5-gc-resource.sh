#!/bin/bash

set -v
kubectl delete ds calico-ipip
kubectl delete svc serversvc

ifconfig br-pool0 down
brctl delbr br-pool0

ifconfig br-pool1 down
brctl delbr br-pool1
