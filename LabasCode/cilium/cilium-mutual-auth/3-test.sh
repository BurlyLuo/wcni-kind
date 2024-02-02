#!/bin/bash
set -v 
controller_node_name=$(docker ps -a --format "table {{.Names}}" | grep control-plane)
docker cp /usr/bin/hubble $controller_node_name:/usr/bin/hubble > /dev/null 2>&1
docker exec -d $controller_node_name bash -c "cilium hubble port-forward &"
