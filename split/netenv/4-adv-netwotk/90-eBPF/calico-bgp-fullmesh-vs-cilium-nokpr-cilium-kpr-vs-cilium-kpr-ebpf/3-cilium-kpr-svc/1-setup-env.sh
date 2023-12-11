# Logical Flow

0. mv config.toml from /etc/containerd/
apt -y install containerd
mv /etc/containerd/config.toml /root/config.toml.bak

1. kubeadm init
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt -y update && 
systemctl restart containerd && systemctl enable containerd
apt-get install -y kubelet=1.27.3-00 kubeadm=1.27.3-00 kubectl=1.27.3-00 --allow-unauthenticated
kubeadm config images pull --image-repository=registry.aliyuncs.com/google_containers
kubeadm init --kubernetes-version=v1.27.3 --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap

2. set private registry
containerd config default > /etc/containerd/config.toml
cat /etc/containerd/config.toml;cat ./config.toml

# For existing installations with kube-proxy running as a DaemonSet, remove it by using the following commands below.Be aware that removing kube-proxy will break existing service connections. It will also stop service related traffic until the Cilium replacement has been installed.

3. delete kube-proxy
$ kubectl -n kube-system delete ds kube-proxy
$ # Delete the configmap as well to avoid kube-proxy being reinstalled during a Kubeadm upgrade (works only for K8s 1.19 and newer)
$ kubectl -n kube-system delete cm kube-proxy
$ # Run on each node with root permissions:
$ iptables-save | grep -v KUBE | iptables-restore

# kubectl -nkube-system patch ds/kube-proxy -p '{"spec": {"template": {"spec": {"nodeSelector": {"kubernetes.io/os": "linux"}}}}}'
kubectl -nkube-system patch ds/kube-proxy -p '{"spec": {"template": {"spec": {"nodeSelector": {"kubernetes.io/os": "cilium-kpr"}}}}}'
iptables-save | grep -v KUBE | iptables-restore
