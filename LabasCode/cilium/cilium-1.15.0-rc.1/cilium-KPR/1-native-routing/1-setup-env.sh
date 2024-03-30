#!/bin/bash
set -v
# 1. Prepare NoCNI kubernetes environment
cat <<EOF | kind create cluster --name=cilium-kpr --image=kindest/node:v1.27.3 --config=-
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
kubectl get nodes | grep cc

# 2. Remove kubernetes node taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. Install CNI[Cilium 1.15.0-rc.1]
cilium_version=v1.15.0-rc.1
docker pull quay.io/cilium/cilium:$cilium_version && docker pull quay.io/cilium/operator-generic:$cilium_version
kind load docker-image quay.io/cilium/cilium:$cilium_version quay.io/cilium/operator-generic:$cilium_version --name cilium-kpr
{ helm repo add cilium https://helm.cilium.io ; helm repo update; } > /dev/null 2>&1

# 3.0: https://docs.cilium.io/en/v1.15/operations/system_requirements/#admin-system-reqs
       # 1. Linux kernel >= 4.19.57 or equivalent (e.g., 4.18 on RHEL8) [uname -r |#|Local: 6.5.0-15-generic]
       # 2. clang+LLVM >= 10.0 [llvm-as --version |#|: Ubuntu LLVM version 14.0.0]
       # 3. When running Cilium without Kubernetes these additional requirements must be met: [Key-Value store etcd >= 3.1.0]
       # 4. Architecture Support [AMD64 && AArch64]
       # 5. Linux Distribution Compatibility & Considerations[lsb_release -a :Description:Ubuntu 22.04.3 LTS |#|uname -r :6.5.0-15-generic]
       # 6. Linux Kernel(https://docs.cilium.io/en/v1.15/operations/system_requirements/#base-requirements) [cat /boot/config-$(uname -r)]
       # 7. Requirements for L7 and FQDN Policies(https://docs.cilium.io/en/v1.15/operations/system_requirements/#requirements-for-l7-and-fqdn-policies)
       # 8. Requirements for IPsec(https://docs.cilium.io/en/v1.15/operations/system_requirements/#requirements-for-ipsec)
       # 9. Requirements for the Bandwidth Manager(https://docs.cilium.io/en/v1.15/operations/system_requirements/#requirements-for-the-bandwidth-manager)
       # 10.Required KernelVersions for AdvancedFeatures(https://docs.cilium.io/en/v1.15/operations/system_requirements/#required-kernel-versions-for-advanced-features)
       # 11.Mounted eBPF filesystem(https://docs.cilium.io/en/v1.15/operations/system_requirements/#mounted-ebpf-filesystem) If the eBPF filesystem is not mounted in the            host filesystem, Cilium will automatically mount the filesystem.
       # 12.Privileges(https://docs.cilium.io/en/v1.15/operations/system_requirements/#privileges)

# 3.1: Native Routing Options(--set routingMode=native --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
       # The Linux kernel on the node must be aware on how to forward packets of pods or other workloads of all nodes running Cilium.This can be achieved in 2 ways:
       # 3.1.1: The node itself does not know how to route all pod IPs but a router exists on the network that knows how to reach all other pods. In this scenario, 
       #       the Linux node is configured to contain a default route to point to such a router.
       # 3.1.2: Each individual node is made aware of all pod IPs of all other nodes and routes are inserted into the Linux kernel routing table to represent this. 
       #       If all nodes share a single L2 network, then this can be taken care of by enabling the option auto-direct-node-routes: true. 
       #       Otherwise, an additional system component such as a BGP daemon must be run to distribute the routes. See the guide Using Kube-Router to Run BGP on 
       #       how to achieve this using the kube-router project.
                     
# 3.2: [The following Helm setup below would be equivalent to kubeProxyReplacement=true in a kube-proxy-free environment:]:[helm install cilium cilium/cilium --version 1.15.0 --namespace kube-system --set kubeProxyReplacement=false --set socketLB.enabled=true --set nodePort.enabled=true --set externalIPs.enabled=true --set hostPort.enabled=true --set k8sServiceHost=${API_SERVER_IP} --set k8sServicePort=${API_SERVER_PORT}]

# 3.3: kubeproxyreplacement Options(--set kubeProxyReplacement=true)

# 3.4: https://docs.cilium.io/en/v1.14/network/kubernetes/kubeproxy-free/#kube-proxy-hybrid-modes

# 3.5: [https://docs.cilium.io/en/v1.15/network/kubernetes/kubeproxy-free/#kubernetes-without-kube-proxy]: Cilium’s kube-proxy replacement depends on the [{"socket-LB"}] feature, which requires a v4.19.57, v5.1.16, v5.2.0 or more recent Linux kernel. Linux kernels v5.3 and v5.8 add additional features that Cilium can use to further optimize the kube-proxy replacement implementation.Note that v5.0.y kernels do not have the fix required to run the kube-proxy replacement since at this point in time the v5.0.y stable kernel is end-of-life (EOL) and not maintained anymore on kernel.org. For individual distribution maintained kernels, the situation could differ. Therefore, please check with your distribution. Cilium’s eBPF kube-proxy replacement is supported in direct routing as well as in tunneling mode.

# 3.6: For existing installations with kube-proxy running as a DaemonSet, remove it by using the following commands: [Be aware that removing kube-proxy will break existing service connections. It will also stop service related traffic until the Cilium replacement has been installed. $ kubectl -n kube-system delete ds kube-proxy $ kubectl -n kube-system delete cm kube-proxy $ iptables-save | grep -v KUBE | iptables-restore]

# 3.7: Cgroup V2 [Cilium will automatically mount cgroup v2 filesystem required to attach BPF cgroup programs by default at the path /run/cilium/cgroupv2. To do that, it needs to mount the host /proc inside an init container launched by the DaemonSet temporarily. If you need to disable the auto-mount, specify --set cgroup.autoMount.enabled=false, and set the host mount point where cgroup v2 filesystem is already mounted by using --set cgroup.hostRoot. For example, if not already mounted, you can mount cgroup v2 filesystem by running the below command on the host, and specify --set cgroup.hostRoot=/sys/fs/cgroup]

# 3.8: Cilium kubeProxyReplacement Limitations: [https://docs.cilium.io/en/v1.15/network/kubernetes/kubeproxy-free/#limitations]


helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.15.0-rc.1 --namespace kube-system --set image.pullPolicy=IfNotPresent --set debug.enabled=true --set debug.verbose="datapath flow kvstore envoy policy" --set bpf.monitorAggregation=none --set monitor.enabled=true --set ipam.mode=cluster-pool --set cluster.name=cilium-kpr --set kubeProxyReplacement=true --set routingMode=native --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8"

# 4. Wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. Cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. Separate namesapce and cgroup v2 verify [https://github.com/cilium/cilium/pull/16259 && https://docs.cilium.io/en/stable/installation/kind/#install-cilium]
for container in $(docker ps -a --format "table {{.Names}}" | grep cilium-kpr);do docker exec $container ls -al /proc/self/ns/cgroup;done
mount -l | grep cgroup && docker info | grep "Cgroup Version" | awk '$1=$1'

