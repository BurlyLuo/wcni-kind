#/bin/bash
set -v
# 1. Deploy multipass vmk(kubeProxyReplacement=true)
for ((i=0; i<${1:-3}; i++))
do
  multipass launch 23.04 -n vmk"$i" -c 2 -m 2G -d 10G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config.d/*.conf
    - sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh
    - sudo mkdir -p /etc/rancher/k3s/ && wget http://192.168.2.100/k3s/registries.yaml -P /etc/rancher/k3s/
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix=/opt/cni/bin/ http://192.168.2.100/k3s/cni/bin/ && find /opt/cni/bin/ -type f | xargs chmod +x
    - sudo bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'
EOF
done

# 2. Prepare kubernetes environment[ubuntu 23.04]
mapfile -t ip_addresses < <(multipass list | grep -E 'vmk' | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++)); do
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1

    echo "${ip_addresses[$ip_id]} vmk$ip_id" >> /etc/hosts

    master_ip=${ip_addresses[0]}
    k3s_version="v1.27.3+k3s1"

    if [ $ip_id -eq 0 ]; then
        k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=kpr
    else
        k3sup join --ip ${ip_addresses[$ip_id]} --user root --sudo --k3s-version=$k3s_version --server-ip $master_ip --server-user root
    fi
done

# 3. Remove kubernetes node taints
until controller_node_ip=$(kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}');[ -n "$controller_node_ip" ];do sleep 1;done
kubectl taint nodes $(kubectl get nodes -o wide | grep control-plane | awk -F " " '{print $1}') node-role.kubernetes.io/control-plane:NoSchedule- > /dev/null 2>&1
kubectl get nodes -o wide

# 4. Install CNI[Cilium 1.15.0-rc.1]
helm repo add cilium https://helm.cilium.io > /dev/null 2>&1
helm repo update > /dev/null 2>&1

# Direct Routing Options(--set tunnel=disabled --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
# kubeproxyreplacement Options(--set kubeProxyReplacement=true)
# eBPF Host Routing(--set bpf.masquerade=true)
# BandwidthManager(--set bandwidthManager.enabled=true)


# 1.0: It is strongly recommended to use Bandwidth Manager in combination with BPF Host Routing as otherwise legacy routing through the upper stack could potentially result in undesired high latency (see this comparison for more details).
# 1.1: [--set devices=ens3] level=warning msg="BPF bandwidth manager could not detect host devices. Disabling the feature." subsys=bandwidth-manager

helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.15.0-rc.1 --namespace kube-system --set image.pullPolicy=IfNotPresent --set debug.enabled=true --set debug.verbose="datapath flow kvstore envoy policy" --set bpf.monitorAggregation=none --set monitor.enabled=true --set ipam.mode=cluster-pool --set cluster.name=cilium-bandwidth-manager --set kubeProxyReplacement=true --set routingMode=native --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set bandwidthManager.enabled=true --set bpf.masquerade=true --set devices=ens3 

# 5. Wait all pods ready
until pod_list=$(kubectl get pods -o wide -A --no-headers);[ -n "$pod_list" ];do sleep 1;done
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 6. Cilium status
kubectl -nkube-system exec -it ds/cilium -- cilium status

