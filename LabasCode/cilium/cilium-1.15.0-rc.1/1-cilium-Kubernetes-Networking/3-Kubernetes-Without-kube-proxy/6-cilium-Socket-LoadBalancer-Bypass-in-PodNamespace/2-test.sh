#!/bin/bash
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
controller_node_name=`kubectl get nodes -o wide | grep control-plane | awk -F " " '{print $1}'`

test_pod_name_at_controller=$(kubectl get pods -owide | grep $controller_node_name | awk -F " " '{print $1}') && echo PodName: $test_pod_name_at_controller
test_pod_ip_at_controller=$(kubectl get pods -owide | grep $controller_node_name | awk -F " " '{print $6}') && echo PodIP: $test_pod_ip_at_controller

# 1. Make a test from Pod to NodePort Service:
echo "********************************************************************"
echo "1. Flow: Pod-->NodePort Service [No Socket Level LB]"
echo "********************************************************************"
echo "kubectl exec -t $test_pod_name_at_controller -- tcpdump -pne -i eth0 &"
kubectl exec -t $test_pod_name_at_controller -- tcpdump -pne -i eth0 &
sleep 1
echo "********************************************************************"
echo "kubectl exec -it $test_pod_name_at_controller -- curl $controller_node_ip:32000"
kubectl exec -it $test_pod_name_at_controller -- curl $controller_node_ip:32000
echo "********************************************************************"
sleep 2
kubectl exec -t $test_pod_name_at_controller -- killall tcpdump

# 2. Make a test from Host to NodePort service:
echo "********************************************************************"
echo "2. Flow: Host-->NodePort Service" [Socket Level LB]
echo "********************************************************************"
echo "kubectl exec -t $test_pod_name_at_controller -- tcpdump -pne -i eth0 &"
kubectl exec -t $test_pod_name_at_controller -- tcpdump -pne -i eth0 &
echo "********************************************************************"
sleep 1
echo "********************************************************************"
echo "kubectl patch service wluo --type merge -p '{"spec": {"internalTrafficPolicy": "Local"}}'"
kubectl patch service wluo --type merge -p '{"spec": {"internalTrafficPolicy": "Local"}}'

echo "docker exec -it $controller_node_name curl $controller_node_ip:32000"
docker exec -it $controller_node_name curl $controller_node_ip:32000
echo "********************************************************************"
sleep 2
kubectl exec -t $test_pod_name_at_controller -- killall tcpdump

