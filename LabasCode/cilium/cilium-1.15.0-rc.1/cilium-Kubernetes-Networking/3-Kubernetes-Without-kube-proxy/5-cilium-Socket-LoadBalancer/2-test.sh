#!/bin/bash
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
controller_node_name=`kubectl get nodes -o wide | grep control-plane | awk -F " " '{print $1}'`

test_pod_name=$(kubectl get pods -owide | grep $controller_node_name | awk -F " " '{print $1}') && echo PodName: $test_pod_name
test_pod_ip=$(kubectl get pods -owide | grep $controller_node_name | awk -F " " '{print $6}') && echo PodIP: $test_pod_ip

kubectl exec -t $test_pod_name -- tcpdump -pne -i eth0 &
sleep 1

kubectl exec -it $test_pod_name -- curl $controller_node_ip:32000
sleep 1
kubectl exec -t $test_pod_name -- killall tcpdump
