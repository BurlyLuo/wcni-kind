#!/bin/bash
set -v
kubectl exec -n kube-system -ti daemonset/tetragon -c tetragon -- tetra getevents -o compact
