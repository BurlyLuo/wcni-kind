#/bin/bash
# 1.0: Create private docker registry
mkdir -p /root/data/docker-registry
docker run -d -v /root/data/docker-registry:/var/lib/registry -p 5000:5000 --restart=always --name registry registry:2

# 2.0: consumer configuration
# 2.1: Docker based:
cat /etc/docker/daemon.json 
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "default-cgroupns-mode": "private",
  "registry-mirrors": ["https://geaiu7n3.mirror.aliyuncs.com"],
  "insecure-registries": ["192.168.2.100:5000"]
}

systemctl daemon-reload && systemctl restart docker

docker tag burlyluo/nettool 192.168.2.100:5000/nettool
docker push 192.168.2.100:5000/nettool
docker pull 192.168.2.100:5000/nettool

# 2.2: containerd based:
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

# cat /etc/containerd/config.toml
version = 2

[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    restrict_oom_score_adj = false
    sandbox_image = "registry.k8s.io/pause:3.7"
    tolerate_missing_hugepages_controller = true
    [plugins."io.containerd.grpc.v1.cri".containerd]
      default_runtime_name = "runc"
      discard_unpacked_layers = true
      snapshotter = "overlayfs"
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          base_runtime_spec = "/etc/containerd/cri-base.json"
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.test-handler]
          base_runtime_spec = "/etc/containerd/cri-base.json"
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.test-handler.options]
            SystemdCgroup = true
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."192.168.2.100:5000"] #
          endpoint = ["http://192.168.2.100:5000"] #

[proxy_plugins]
  [proxy_plugins.fuse-overlayfs]
    address = "/run/containerd-fuse-overlayfs.sock"
    type = "snapshot"


# 3.0: k3s based
for ((i=0; i<${1:-3}; i++))
do
  multipass launch 22.04 -n vmk"$i" -c 3 -m 3G -d 30G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    - sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart sshd
    - sudo mkdir -p /etc/rancher/k3s/ && wget http://192.168.2.100/k3s/registries.yaml -P /etc/rancher/k3s/
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix=/opt/cni/bin/ http://192.168.2.100/k3s/cni/bin/ && find /opt/cni/bin/ -type f | xargs chmod +x
    - sudo bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'
EOF
done

# http://192.168.2.100/k3s/registries.yaml
cat registries.yaml 
mirrors:
  "192.168.2.100:5000":
    endpoint:
      - "http://192.168.2.100:5000"

