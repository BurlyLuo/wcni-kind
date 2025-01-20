#!/bin/bash
set -v

# host version [22.04.3] https://fridge.ubuntu.com/2023/08/11/ubuntu-22-04-3-lts-released/
# dock version [23.0.1 ] https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/

# clab version [v0.59.0] https://github.com/srl-labs/containerlab/releases/download/v0.59.0/containerlab_0.59.0_linux_amd64.tar.gz
# vyos version [v1.4.9 ] docker pull burlyluo/vyos:1.4.9

# kind version [v0.20.0] https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-amd64
# imge version [v1.27.3] docker pull burlyluo/kindest:v1.27.3

# phub version [v2.7.1 ] docker pull docker.io/registry:2  
  # run p_hub: [docker run -d --network=host --restart=always --name phub registry:2]

# nettool imge [v1.1.11] docker pull burlyluo/nettool:latest
# iptables fwd [iptables -L | grep policy || and then: systemctl cat docker >> ExecStartPost=/sbin/iptables -P FORWARD ACCEPT]

# Auther name: [Wei Luo]
# Mail address [olaf.luo@foxmail.com]
# Docs address [https://www.yuque.com/wei.luo]
# Bootcamp url [https://youdianzhishi.com/web/course/1041]
# Issue report [https://github.com/BurlyLuo/wcni-kind/issues or https://gitee.com/rowan-wcni/wcni-kind/issues]


# 1.prep noCNI env
alias addk3s
addk3s
# alias addk3s='rm -rf /usr/local/bin/k3s/ ; wget http://192.168.2.100/http/k3s -P /usr/local/bin/ && chmod +x /usr/local/bin/k3s && INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_EXEC='\''--docker --flannel-backend=none --disable=traefik --disable=servicelb'\'' /root/wcni-kind/LabasCode/k8senv/vmenv/k3senv/k3s-install.sh && export KUBECONFIG=/etc/rancher/k3s/k3s.yaml'

# 2.remove taints
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide


# for i in $(docker ps --format '{{.Names}}'| grep cni-multus- | grep -v clab);do docker exec -it $i bash -c "sysctl kernel.unprivileged_bpf_disabled=0";done

# 3. install CNI[Calico v3.23.2] and afxdp-plugin
kubectl apply -f ./k8snetworkplumbingwg

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
