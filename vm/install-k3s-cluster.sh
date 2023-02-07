#/bin/bash
multipass launch 20.04 -n k3s-master0 -c 2 -m 2G -d 10G
multipass launch 20.04 -n k3s-worker1 -c 1 -m 1G -d 10G
multipass launch 20.04 -n k3s-worker2 -c 1 -m 1G -d 10G



# Deploy k3s on the master node
multipass exec k3s-master0 -- /bin/bash -c "curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn | K3S_KUBECONFIG_MODE="644" | INSTALL_K3S_VERSION="v1.23.16+k3s1" sh -"

# Get the IP of the master node
K3S_NODEIP_MASTER="https://$(multipass info k3s-master0 | grep "IPv4" | awk -F' ' '{print $2}'):6443"

# Get the TOKEN from the master node
K3S_TOKEN="$(multipass exec k3s-master0 -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")"

# Deploy k3s on the worker node
multipass exec k3s-worker1 -- /bin/bash -c "curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -"

# Deploy k3s on the worker node
multipass exec k3s-worker2 -- /bin/bash -c "curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -"


