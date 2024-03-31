#/bin/bash
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
controller_node_name=`kubectl get nodes -o wide | grep control-plane | awk -F " " '{print $1}'`

test_pod_name=$(kubectl get pods -owide | grep $controller_node_name | awk -F " " '{print $1}') && echo PodName: $test_pod_name
test_pod_ip=$(kubectl get pods -owide | grep $controller_node_name | awk -F " " '{print $6}') && echo PodIP: $test_pod_ip

curl $controller_node_ip:32000

cilium_ds_pod=$(for i in $(kubectl -nkube-system get pods -o name | grep -e '^[^-]*-[^-]*$' | awk -F "/" '{print $2}');do kubectl -nkube-system exec -it $i -c cilium-agent -- env | grep $controller_node_name>/dev/null;if [ $? -eq 0 ]; then echo $i;fi;done)
echo $cilium_ds_pod


echo "********************************************************************"
echo Test_Node_IP: $controller_node_ip
echo Test_Pod_IP: $test_pod_ip
echo "********************************************************************"
echo "**********************************************************************************"
echo "kubectl -nkube-system exec -it $cilium_ds_pod -c cilium-agent -- cilium service list"
echo "**********************************************************************************"
kubectl -nkube-system exec -it $cilium_ds_pod -c cilium-agent -- cilium service list

echo "****************************************************************************"
echo "kubectl get svc -o yaml wluo -ojsonpath={.spec.externalTrafficPolicy}" 
kubectl get svc -o yaml wluo -ojsonpath={.spec.externalTrafficPolicy} && echo 

echo "****************************************************************************"
echo "There only one Backend:" $test_pod_ip "for the NodePort Service:" $controller_node_ip:32000
echo "****************************************************************************"

echo "No available backend pod"
kubectl taint node $controller_node_name node-role.kubernetes.io/control-plane:NoSchedule
will_delete_pod=$(kubectl get pods -o wide | grep $controller_node_name | awk -F " " '{print $1}')
kubectl delete pods $will_delete_pod

echo "Test NodePort Service"
curl $controller_node_ip:32000

echo "****************************************************************************"
echo "This is expected. due to there is no available backend pods!"
echo "****************************************************************************"
