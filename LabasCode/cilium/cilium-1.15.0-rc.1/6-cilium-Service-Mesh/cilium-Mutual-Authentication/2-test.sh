#!/bin/bash
set -v 

echo "https://docs.cilium.io/en/v1.15/network/servicemesh/mutual-authentication/mutual-authentication-example/"

# 0.0: Non CiliumNetworkPolicy Apply.
kubectl exec -it pod-worker -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers
kubectl exec -it pod-deny-client -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers

# 1.0: Make a non-mutual-auth demo
kubectl apply -f ./mutual-auth/mutual-auth-example.yaml
kubectl apply -f ./mutual-auth/cnp-without-mutual-auth.yaml

# 1.1: Verify that the network policy has been deployed successfully and filters the traffic as expected. The first request should be successful (the pod-worker Pod is able to connect to the echo Service over a specific HTTP path and the HTTP status code is 200). The second one should be denied (the pod-worker Pod is unable to connect to the echo Service over a specific HTTP path other than ‘/headers’).
# kubectl exec -it pod-worker -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers
# 200
# kubectl exec -it pod-worker -- curl http://echo:8080/headers-1
# Access denied
# kubectl exec -it pod-deny-client -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers
# Drop(From hubble UI)

# 1.2: with expected path(headers)
kubectl exec -it pod-worker -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers

# 1.3: with un-expected path(headers-1)
kubectl exec -it pod-worker -- curl http://echo:8080/headers-1

# 1.4: spec the different client that can't allow to access the target the svc.
kubectl exec -it pod-deny-client -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers

# 2.0: Enable mutual authentication[kubectl exec -n cilium-spire spire-server-0 -c spire-server -- /opt/spire/bin/spire-server healthcheck]
kubectl exec -n cilium-spire spire-server-0 -c spire-server -- /opt/spire/bin/spire-server healthcheck
# 2.1: Verify the list of attested agents:
kubectl exec -n cilium-spire spire-server-0 -c spire-server -- /opt/spire/bin/spire-server agent list

# Enforce Mutual Authentication[authentication.mode: "required"]
kubectl apply -f ./mutual-auth/cnp-with-mutual-auth.yaml
# 2.2: with expected path(headers)[Enable mutual auth]
kubectl exec -it pod-worker -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers

# 2.3: with un-expected path(headers-1)[Enable mutual auth]
kubectl exec -it pod-worker -- curl http://echo:8080/headers-1

# 2.4: with deny list pod to access the svc
kubectl exec -it pod-deny-client -- curl -s -o /dev/null -w "%{http_code}" http://echo:8080/headers

# 3.0: Check logs
echo_pod_node_name=$(kubectl get pods -oname -o wide | grep echo | awk -F " " '{print $7}')
cilium_ds_pod_name=$(kubectl -nkube-system get pods -o wide | grep -w $echo_pod_node_name | grep -v cilium-operator- | grep cilium- | awk -F " " '{print $1}')
kubectl -nkube-system logs $cilium_ds_pod_name -c cilium-agent --timestamps=true | grep "Policy is requiring authentication\|Validating Server SNI\|Validated certificate\|Successfully authenticated"

