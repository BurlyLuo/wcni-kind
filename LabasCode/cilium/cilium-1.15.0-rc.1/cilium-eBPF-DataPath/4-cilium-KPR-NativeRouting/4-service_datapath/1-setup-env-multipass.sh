#/bin/bash
set -v
# 1. Deploy multipass vmn(kubeProxyReplacement=false(default))
for ((i=0; i<${1:-3}; i++))
do
  multipass launch 22.04 -n vmn"$i" -c 3 -m 3G -d 30G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config.d/*.conf
    - sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart sshd
    - sudo mkdir -p /etc/rancher/k3s/ && wget http://192.168.2.100/k3s/registries.yaml -P /etc/rancher/k3s/
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix=/opt/cni/bin/ http://192.168.2.100/k3s/cni/bin/ && find /opt/cni/bin/ -type f | xargs chmod +x
    - sudo bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'
EOF
done

# 2. prep env[ubuntu 22.04]
mapfile -t ip_addresses < <(multipass list | grep -E 'vmn' | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++)); do
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1

    echo "${ip_addresses[$ip_id]} vmn$ip_id" >> /etc/hosts

    master_ip=${ip_addresses[0]}
    k3s_version="v1.27.3+k3s1"

    if [ $ip_id -eq 0 ]; then
        # --k3s-extra-args can refer: k3s server -h | grep flannel-backend
	k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=nokpr
    else
        k3sup join --ip ${ip_addresses[$ip_id]} --user root --sudo --k3s-version=$k3s_version --server-ip $master_ip --server-user root
    fi
done

# 3. Install Cilium CNI
{ helm repo add cilium https://helm.cilium.io ; helm repo update; } > /dev/null 2>&1
controller_node_ip=`kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}'`
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-

# Direct Routing Options(--set routingMode=native --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8")
helm install cilium cilium/cilium --set k8sServiceHost=$controller_node_ip --set k8sServicePort=6443 --version 1.15.0-rc.1 --namespace kube-system --set image.pullPolicy=IfNotPresent --set debug.enabled=true --set debug.verbose="datapath flow kvstore envoy policy" --set bpf.monitorAggregation=none --set monitor.enabled=true --set ipam.mode=cluster-pool --set cluster.name=cilium-kpr --set kubeProxyReplacement=true --set routingMode=native --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8"

# 4. Wait all pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# 5. Cilium status(cilium status --verbose)
kubectl -nkube-system exec -it ds/cilium -- cilium status

# 6. Create Pod & Service
./2-test.sh

