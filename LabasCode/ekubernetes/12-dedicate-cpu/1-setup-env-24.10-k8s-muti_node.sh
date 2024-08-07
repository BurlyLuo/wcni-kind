#/bin/bash
set -v

if [ ${1:-1} -ge 2 ]; then cpu=4;mem=4G;else cpu=8;mem=8G;fi

for ((i=0; i<${1:-1}; i++))
do
  multipass launch daily:24.10 -n vm2410"$i" -c $cpu -m $mem -d 30G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config.d/*.conf
    - sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh
    - sudo mkdir -p /etc/rancher/k3s/ && wget http://192.168.2.100/k3s/registries.yaml -P /etc/rancher/k3s/
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix=/opt/cni/bin/ http://192.168.2.100/k3s/cni/bin/ && find /opt/cni/bin/ -type f | xargs chmod +x
    - sudo bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias vi=\"vim\""; echo "alias ll=\"ls -lF\""; } >> ~/.bashrc'
    - sudo wget http://192.168.2.100/k3s/cilium-related/helm -P /usr/bin/ && chmod +x /usr/bin/helm
    - sudo wget http://192.168.2.100/k3s/cilium-related/kubectl -P /usr/bin/ && chmod +x /usr/bin/kubectl
    - sudo wget http://192.168.2.100/k3s/rzsz/rz -P /usr/bin/ && wget http://192.168.2.100/k3s/rzsz/sz -P /usr/bin/ && chmod +x /usr/bin/rz /usr/bin/sz
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix="/root/" http://192.168.2.100/k3s/vmenv/mmenv/ubuntu2304/ && chmod +x "/root/ubuntu2304/pwru.sh" 
    - sudo find /root/ubuntu2304/ -name index.html -exec rm {} \;
EOF
done
# 2. prep env[ubuntu 24.10]
mapfile -t ip_addresses < <(multipass list | grep -E 'vm2410' | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++)); do
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1

    echo "${ip_addresses[$ip_id]} vm2410$ip_id" >> /etc/hosts

    master_ip=${ip_addresses[0]}
    k3s_version="v1.27.3+k3s1"

    if [ $ip_id -eq 0 ]; then
        # --k3s-extra-args can refer: k3s server -h | grep flannel-backend
        k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=2410ctx
    else
        k3sup join --ip ${ip_addresses[$ip_id]} --user root --sudo --k3s-version=$k3s_version --server-ip $master_ip --server-user root
    fi
done

# 3. Install Cilium CNI
cilium install --version 1.16.0-rc.1 --set k8sServiceHost=$master_ip --set k8sServicePort=6443 --namespace kube-system --set routingMode=native --set bpf.masquerade=true --set kubeProxyReplacement=true --set ipam.mode=kubernetes --set autoDirectNodeRoutes=true --set ipv4NativeRoutingCIDR="10.0.0.0/8" --set bpf.datapathMode=netkit

