#!/bin/bash
# 1.  Cilium ClsterMesh service-affinity prepare
NAME=cluster
NAMESPACE=service-affinity

kubectl --context kind-${NAME}1 create ns $NAMESPACE
kubectl --context kind-${NAME}2 create ns $NAMESPACE
kubectl --context kind-${NAME}1 -n $NAMESPACE apply -f netshoot-ds.yaml
kubectl --context kind-${NAME}2 -n $NAMESPACE apply -f netshoot-ds.yaml
kubectl --context kind-${NAME}1 -n $NAMESPACE apply -f echoserver-service.yaml
kubectl --context kind-${NAME}2 -n $NAMESPACE apply -f echoserver-service.yaml
cilium clustermesh status --context kind-${NAME}1 --wait
cilium clustermesh status --context kind-${NAME}2 --wait


kubectl -n$NAMESPACE wait --for=condition=Ready=true pods --all --context kind-${NAME}1 --field-selector=status.phase!=Succeeded
kubectl -n$NAMESPACE wait --for=condition=Ready=true pods --all --context kind-${NAME}2 --field-selector=status.phase!=Succeeded

# 2. Test Cilium ClsterMesh service-affinity
NREQUESTS=9

kubectl config use-context kind-cluster1

echo "-----------------------------------------------------------"
echo Current_Context View:
echo "-----------------------------------------------------------"
kubectl config get-contexts

for affinity in local remote none; do
  echo "-----------------------------------------------------------"
  rm -f $affinity.txt
  echo "Sending $NREQUESTS requests to service-affinity=$affinity service mode"
  echo "-----------------------------------------------------------"
  for i in $(seq 1 $NREQUESTS); do
  Current_Cluster=`kubectl -n service-affinity exec -it ds/netshoot -- curl -q "http://echoserver-service-$affinity.service-affinity.svc.cluster.local?echo_env_body=NODE"` 
  echo -e Current_Rsp_From_Cluster: ${Current_Cluster}
  done
done
echo "-----------------------------------------------------------"

