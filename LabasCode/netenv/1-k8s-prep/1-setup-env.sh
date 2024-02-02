#!/bin/bash
date
set -v

# [private docker registry]
docker run -d -p 5000:5000 -v /data/registry:/var/lib/registry --restart=always --name registry registry:2

# [common configuration]
# 1.prep env
cat <<EOF>> /etc/hosts
192.168.2.71 bpf1
192.168.2.72 bpf2
192.168.2.73 bpf3
EOF

# 2.set the kernel parameter
cat <<EOF>> /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
EOF

sed -ri 's/.*swap.*/#&/' /etc/fstab
swapoff -a

# 3.Add kubernetes repo
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
tee /etc/apt/sources.list.d/kubernetes.list <<-'EOF'
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update

# 4.Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
sudo apt install docker-ce docker-ce-cli containerd.io
cat <<EOF > /etc/docker/daemon.json
{
  "insecure-registries": ["192.168.2.100:5000"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://cu2yw19m.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload;systemctl restart docker;systemctl enable docker


# 5.Install kubeadm,kubelet,kubectl
apt-get install -y kubelet=1.23.4-00 kubeadm=1.23.4-00 kubectl=1.23.4-00 --allow-unauthenticated
systemctl restart kubelet;systemctl enable kubelet 


# [master node]
# 1.mod kubelet configuration
mkdir -p /var/lib/kubelet/
cat > /var/lib/kubelet/config.yaml <<EOF      
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF
systemctl restart kubelet;systemctl enable kubelet
docker info|grep "Cgroup Driver"

# 2.INIT Master
# with kube-proxy
kubeadm config images pull --image-repository=registry.aliyuncs.com/google_containers
kubeadm init --kubernetes-version=v1.23.4 --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap

# without kube-proxy
kubeadm init --kubernetes-version=v1.23.4 --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --skip-phases=addon/kube-proxy --ignore-preflight-errors=Swap

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master-

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# [Worker node]
kubeadm config images pull --image-repository=registry.aliyuncs.com/google_containers
kubeadm join 192.168.2.61:6443 --token ac4k64.e3i6j13sryj1twzt \
        --discovery-token-ca-cert-hash sha256:7feb5f701bbad147116daddda3e74e720738e61938eedccc7bfaa3d24aed23bf 


$ kubectl get nodes -owide 
NAME   STATUS     ROLES                  AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
bpf1   NotReady   control-plane,master   160d   v1.23.4   192.168.2.71   <none>        Ubuntu 20.04.5 LTS   5.15.0-52-generic   docker://20.10.21
bpf2   NotReady   <none>                 160d   v1.23.4   192.168.2.72   <none>        Ubuntu 20.04.5 LTS   5.15.0-52-generic   docker://20.10.21
bpf3   NotReady   <none>                 160d   v1.23.4   192.168.2.73   <none>        Ubuntu 20.04.5 LTS   5.15.0-52-generic   docker://20.10.21

