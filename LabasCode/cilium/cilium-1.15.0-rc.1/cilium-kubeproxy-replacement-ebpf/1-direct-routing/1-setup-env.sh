#!/bin/bash
date
set -v

# 1. prep noCNI env
cat <<EOF | kind create cluster --name=cilium-kubeproxy-replacement --image=kindest/node:v1.27.3 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  kubeProxyMode: "none" # Disable Kubernetes KubeProxy

nodes:
  - role: control-plane
  - role: worker
  - role: worker
        
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"]
    endpoint = ["http://192.168.2.100:5000"]
EOF

# 2. remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. install cni[Cilium 1.15.0-rc.1]
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# 3.1: Direct Routing Options(--set routingMode=native --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# 3.2: [The following Helm setup below would be equivalent to kubeProxyReplacement=true in a kube-proxy-free environment:]:[helm install cilium cilium/cilium --version 1.15.0 --namespace kube-system --set kubeProxyReplacement=false --set socketLB.enabled=true --set nodePort.enabled=true --set externalIPs.enabled=true --set hostPort.enabled=true --set k8sServiceHost=${API_SERVER_IP} --set k8sServicePort=${API_SERVER_PORT}]
# 3.3: kubeproxyreplacement Options(--set kubeProxyReplacement=true)
# 3.4: https://docs.cilium.io/en/v1.14/network/kubernetes/kubeproxy-free/#kube-proxy-hybrid-modes
# 3.5: [https://docs.cilium.io/en/v1.15/network/kubernetes/kubeproxy-free/#kubernetes-without-kube-proxy]: Cilium’s kube-proxy replacement depends on the [{"socket-LB"}] feature, which requires a v4.19.57, v5.1.16, v5.2.0 or more recent Linux kernel. Linux kernels v5.3 and v5.8 add additional features that Cilium can use to further optimize the kube-proxy replacement implementation.Note that v5.0.y kernels do not have the fix required to run the kube-proxy replacement since at this point in time the v5.0.y stable kernel is end-of-life (EOL) and not maintained anymore on kernel.org. For individual distribution maintained kernels, the situation could differ. Therefore, please check with your distribution. Cilium’s eBPF kube-proxy replacement is supported in direct routing as well as in tunneling mode.
# 3.6: For existing installations with kube-proxy running as a DaemonSet, remove it by using the following commands: [Be aware that removing kube-proxy will break existing service connections. It will also stop service related traffic until the Cilium replacement has been installed. $ kubectl -n kube-system delete ds kube-proxy $ kubectl -n kube-system delete cm kube-proxy $ iptables-save | grep -v KUBE | iptables-restore]
# 3.7: Cgroup V2 [Cilium will automatically mount cgroup v2 filesystem required to attach BPF cgroup programs by default at the path /run/cilium/cgroupv2. To do that, it needs to mount the host /proc inside an init container launched by the DaemonSet temporarily. If you need to disable the auto-mount, specify --set cgroup.autoMount.enabled=false, and set the host mount point where cgroup v2 filesystem is already mounted by using --set cgroup.hostRoot. For example, if not already mounted, you can mount cgroup v2 filesystem by running the below command on the host, and specify --set cgroup.hostRoot=/sys/fs/cgroup]
# 3.8: Cilium kubeProxyReplacement Limitations: [https://docs.cilium.io/en/v1.15/network/kubernetes/kubeproxy-free/#limitations]
# 3.9: eBPF Host Routing(--set bpf.masquerade=true)

helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.15.0-rc.1 --namespace kube-system --set debug.enabled=true --set debug.verbose="datapath flow kvstore envoy policy" --set bpf.monitorAggregation=none --set monitor.enabled=true --set nodeinit.enabled=true --set ipam.mode=cluster-pool --set cluster.name=cilium-kubeproxy-replacement --set kubeProxyReplacement=true --set routingMode=native --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set bpf.masquerade=true

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. separate namesapce and cgroup v2 verify [https://github.com/cilium/cilium/pull/16259 && https://docs.cilium.io/en/stable/installation/kind/#install-cilium]
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-kubeproxy-replacement);do docker exec $container ls -al /proc/self/ns/cgroup;done
mount -l | grep cgroup && docker info | grep "Cgroup Version" | awk '$1=$1'

