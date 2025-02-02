#!/bin/bash
k8s_name=flannel-udp; c_node_name=$k8s_name-control-plane; w_node_name=$k8s_name-worker
node_list=$(kubectl get nodes -owide); pod_list=$(kubectl get pods -owide)

c_node_ip=$(echo "$node_list" | grep $c_node_name | awk '{print $6}'); w_node_ip=$(echo "$node_list" | grep $w_node_name | awk '{print $6}')
c_pod_name=$(echo "$pod_list" | grep $c_node_name | awk '{print $1}'); w_pod_name=$(echo "$pod_list" | grep $w_node_name | awk '{print $1}')
c_pod_ip=$(echo "$pod_list" | grep $c_node_name | awk '{print $6}'); w_pod_ip=$(echo "$pod_list" | grep $w_node_name | awk '{print $6}')
c_pod_mac=$(kubectl exec -it $c_pod_name -- ip link show eth0 | awk '/link\/ether/ {print $2}')
w_pod_mac=$(kubectl exec -it $w_pod_name -- ip link show eth0 | awk '/link\/ether/ {print $2}')

pod_to_node() {
  pod_eth_name=$(kubectl exec -it $c_pod_name -- ip r s | grep default | awk '{print $5}')
  kubectl exec $c_pod_name -- tcpdump -pne -i $pod_eth_name -c 5 arp or icmp -vv & > /dev/null 2>&1 &

  echo "# 1.Pod $c_pod_name ip routing table:"
  commands=("ip r s" "ip n s" "ip n f all")
  for cmd in "${commands[@]}"; do
    echo "# $cmd"
    kubectl exec -it $c_pod_name -- bash -c "$cmd"
  done

  echo "# 2.Pod $c_pod_name@$c_node_name ping Pod $w_pod_name@$w_node_name:" 
  echo "c_pod_mac: $c_pod_mac ||| w_pod_mac: $w_pod_mac"
  echo "# kubectl exec -it $c_pod_name -- ping $w_pod_ip -I $c_pod_ip -c 1 -W 1"
  sleep 0.5 && kubectl exec -it $c_pod_name -- ping $w_pod_ip -I $c_pod_ip -c 1 -W 1
  echo "# kubectl exec $c_pod_name -- tcpdump -pne -i $pod_eth_name -c 5 arp or icmp"
}
pod_to_node

