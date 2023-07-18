#/bin/bash
set -v

# 1. Deploy multipass vm
multipass stop --all;multipass delete --all;multipass purge;multipass list;sed -i '1!d' /root/.ssh/known_hosts > /dev/null 2>&1

multipass launch 22.04 -n k3s-master0 -c 2 -m 2.5G -d 10G --cloud-init - <<EOF
# cloud-config
runcmd:
  - sudo echo 'ubuntu:hive' | chpasswd
  - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  - echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
  - echo 'root:hive' | sudo chpasswd
  - sudo systemctl restart sshd
EOF

multipass launch 22.04 -n k3s-worker1 -c 2 -m 2G -d 10G --cloud-init - <<EOF
# cloud-config
runcmd:
  - sudo echo 'ubuntu:hive' | chpasswd
  - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  - echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
  - echo 'root:hive' | sudo chpasswd
  - sudo systemctl restart sshd
EOF

multipass launch 22.04 -n k3s-worker2 -c 2 -m 2G -d 10G --cloud-init - <<EOF
# cloud-config
runcmd:
  - sudo echo 'ubuntu:hive' | chpasswd
  - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  - echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
  - echo 'root:hive' | sudo chpasswd
  - sudo systemctl restart sshd
EOF

# 2. prep env[ubuntu 22.04]
for ip in $(multipass list | awk -F " " '{if (NR>1){print $3}}')
do  
    echo $ip
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@$ip > /dev/null 2>&1
done    

k3s_master0_ip=`(multipass list | grep master0 | awk -F " " '{print $3}')`
k3s_worker1_ip=`(multipass list | grep worker1 | awk -F " " '{print $3}')`
k3s_worker2_ip=`(multipass list | grep worker2 | awk -F " " '{print $3}')`

k3sup install --ip=$k3s_master0_ip --user=root --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=$k3s_master0_ip" --local-path $HOME/.kube/config --context=k3s-ha

k3sup join --ip $k3s_worker1_ip --user root --sudo --k3s-version=v1.27.3+k3s1 --server --server-ip $k3s_master0_ip --server-user root --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=$k3s_worker1_ip"

k3sup join --ip $k3s_worker2_ip --user root --sudo --k3s-version=v1.27.3+k3s1 --server --server-ip $k3s_master0_ip --server-user root --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=$k3s_worker2_ip"

# 3.install cni
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# kubeproxyreplacement Options(--set kubeProxyReplacement=true)
# eBPF Host Routing(--set bpf.masquerade=true)
# bandwidthManager(--set bandwidthManager.enabled=true)
helm install cilium cilium/cilium --set k8sServiceHost=$k3s_master0_ip --set k8sServicePort=6443 --version 1.14.0-rc.0 --namespace kube-system --set debug.enabled=true --set debug.verbose=datapath --set monitorAggregation=none --set ipam.mode=cluster-pool --set cluster.name=cilium-bandwidth-manager --set kubeProxyReplacement=true --set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set bpf.masquerade=true --set bandwidthManager.enabled=true 

# 4. wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

