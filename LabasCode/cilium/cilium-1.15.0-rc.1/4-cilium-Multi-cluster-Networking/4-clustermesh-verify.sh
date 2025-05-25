#/bin/bash
set -v
rm -rf cluster1.yaml cluster2.yaml
wget https://raw.githubusercontent.com/cilium/cilium/1.11.2/examples/kubernetes/clustermesh/global-service-example/cluster1.yaml
wget https://raw.githubusercontent.com/cilium/cilium/1.11.2/examples/kubernetes/clustermesh/global-service-example/cluster2.yaml
# sed -i "s/image: docker.io/image: 192.168.2.100:5000/g" cluster1.yaml 
# sed -i "s/image: docker.io/image: 192.168.2.100:5000/g" cluster2.yaml

kubectl apply -f ./cluster1.yaml --context kind-cluster1
kubectl apply -f ./cluster2.yaml --context kind-cluster2

kubectl wait --for=condition=Ready=true pods --all --context kind-cluster1
kubectl wait --for=condition=Ready=true pods --all --context kind-cluster2

for i in $(seq 1 10);do kubectl --context kind-cluster1 exec -ti deployment/x-wing -- curl rebel-base;done

# Cluster Failover
sleep 3
kubectl --context kind-cluster2 scale deployment rebel-base --replicas=0 

for i in $(seq 1 10);do kubectl --context kind-cluster1 exec -ti deployment/x-wing -- curl rebel-base;done

