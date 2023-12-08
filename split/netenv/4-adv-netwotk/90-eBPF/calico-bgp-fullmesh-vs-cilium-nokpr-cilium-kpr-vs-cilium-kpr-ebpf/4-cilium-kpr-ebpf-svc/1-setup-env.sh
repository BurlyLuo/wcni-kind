$ file ds
mv /etc/containerd/config.toml /root/config.toml.bak
systemctl restart containerd && systemctl enable containerd
kubeadm config images pull --image-repository=registry.aliyuncs.com/google_containers
kubeadm init --kubernetes-version=v1.27.3 --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap

cat /etc/containerd/config.toml;cat ./config.toml

# For existing installations with kube-proxy running as a DaemonSet, remove it by using the following commands below.Be aware that removing kube-proxy will break existing service connections. It will also stop service related traffic until the Cilium replacement has been installed.

$ kubectl -n kube-system delete ds kube-proxy
$ # Delete the configmap as well to avoid kube-proxy being reinstalled during a Kubeadm upgrade (works only for K8s 1.19 and newer)
$ kubectl -n kube-system delete cm kube-proxy
$ # Run on each node with root permissions:
$ iptables-save | grep -v KUBE | iptables-restore

