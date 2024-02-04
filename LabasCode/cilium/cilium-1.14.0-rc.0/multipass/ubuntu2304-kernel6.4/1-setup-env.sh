#/bin/bash
set -v

# 1. Deploy multipass vm
multipass stop --all;multipass delete --purge --all;{ sed -i '1!d' /root/.ssh/known_hosts && kubectl config delete-context k3s-ha; } > /dev/null 2>&1

for node in k3s-master0 k3s-worker1 k3s-worker2
do
  multipass launch 23.04 -n $node -c 2 -m 2G -d 10G --cloud-init - <<'EOF'
  # cloud-config
  runcmd:
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config.d/*.conf
    - sudo echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    - echo 'root:hive' | sudo chpasswd
    - sudo systemctl restart ssh
    - sudo wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.4/amd64/linux-headers-6.4.0-060400-generic_6.4.0-060400.202306271339_amd64.deb
    - sudo wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.4/amd64/linux-headers-6.4.0-060400_6.4.0-060400.202306271339_all.deb
    - sudo wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.4/amd64/linux-image-unsigned-6.4.0-060400-generic_6.4.0-060400.202306271339_amd64.deb
    - sudo wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.4/amd64/linux-modules-6.4.0-060400-generic_6.4.0-060400.202306271339_amd64.deb
    - sudo dpkg -i *.deb
    - sudo reboot
EOF
done

# 2. prep env[ubuntu 23.04]
mapfile -t ip_addresses < <(multipass list | grep -E 'k3s-master0|k3s-worker1|k3s-worker2' | awk '{print $3}')

for ip_id in 0 1 2;do sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1;done

k3sup install --ip=${ip_addresses[0]} --user=root --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=${ip_addresses[0]}" --local-path $HOME/.kube/config --context=k3s-ha

k3sup join --ip ${ip_addresses[1]} --user root --sudo --k3s-version=v1.27.3+k3s1 --server --server-ip ${ip_addresses[0]} --server-user root --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=${ip_addresses[1]}"

k3sup join --ip ${ip_addresses[2]} --user root --sudo --k3s-version=v1.27.3+k3s1 --server --server-ip ${ip_addresses[0]} --server-user root --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=${ip_addresses[2]}"

# 3. install cni
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# kubeproxyreplacement Options(--set kubeProxyReplacement=true)
# eBPF Host Routing(--set bpf.masquerade=true)
# bbr(--set bandwidthManager.enabled=true --set bandwidthManager.bbr=true --set bpf.masquerade=true)[--set bpf.masquerade=true required the feature]
# IPV4 BIG TCP Options(--set ipv4.enabled=true --set enableIPv4BIGTCP=true)
helm install cilium cilium/cilium --set k8sServiceHost=${ip_addresses[0]} --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-bbr --set kubeProxyReplacement=true --set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set bandwidthManager.enabled=true --set bandwidthManager.bbr=true --set bpf.masquerade=true --set ipv4.enabled=true --set enableIPv4BIGTCP=true

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

