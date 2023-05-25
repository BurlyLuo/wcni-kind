#!/bin/bash
set -v
# exec &>./clustermesh-connect-log-rec.txt
date

cilium clustermesh enable --context kind-cluster1 --service-type NodePort
cilium clustermesh enable --context kind-cluster2 --service-type NodePort

cilium clustermesh connect --context kind-cluster1 --destination-context kind-cluster2

cilium clustermesh status  --context kind-cluster1 --wait

