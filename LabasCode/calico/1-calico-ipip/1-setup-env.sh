#!/bin/bash
set -v
# 1. Prepare NoCNI environment
cat <<EOF | kind create cluster --name=calico-ipip --image=kindest/node:v1.27.3 -v=9 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
nodes:
  - role: control-plane
  - role: worker

containerdConfigPatches:
  - |-
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
      endpoint = ["http://192.168.2.100:5000"]
  - |-
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."https://dockerproxy.com"]
      endpoint = ["https://dockerproxy.com"]
EOF

# 2. Remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. Collect startup message
controller_node_name=$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep control-plane)
if [ -n "$controller_node_name" ]; then
  timeout 1 docker exec -t $controller_node_name bash -c 'cat << EOF > /root/monitor_startup.sh
#!/bin/bash
ip -ts monitor all > /root/startup_monitor.txt 2>&1
EOF
chmod +x /root/monitor_startup.sh && /root/monitor_startup.sh'
else
  echo "No such controller_node!"
fi

# 4. Install CNI[Calico v3.23.2]
kubectl apply -f calico.yaml

# 5. Wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

