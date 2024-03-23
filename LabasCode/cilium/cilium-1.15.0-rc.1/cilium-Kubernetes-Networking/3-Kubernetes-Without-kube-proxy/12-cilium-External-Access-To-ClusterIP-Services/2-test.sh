#!/bin/bash
controller_node_name=`kubectl get nodes -o wide | grep control-plane | awk -F " " '{print $1}'`

echo "docker exec -it $controller_node_name ip n s"
docker exec -it $controller_node_name ip n s 

