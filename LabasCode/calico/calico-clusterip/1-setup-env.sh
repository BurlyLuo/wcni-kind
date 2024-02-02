#/bin/bash
set -v

# 1. Deploy multipass vmn(kubeProxyReplacement=false(default))
for ((i=0; i<${1:-3}; i++))
do
  multipass launch 22.04 -n vmn"$i" -c 3 -m 3G -d 30G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
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

    scp ./3-iptables-trace.sh root@${ip_addresses[$ip_id]}:/root/

    master_ip=${ip_addresses[0]}
    k3s_version="v1.27.3+k3s1"

    if [ $ip_id -eq 0 ]; then
	k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=nokpr
    else
        k3sup join --ip ${ip_addresses[$ip_id]} --user root --sudo --k3s-version=$k3s_version --server-ip $master_ip --server-user root
    fi
done

until controller_node_ip=$(kubectl get node -o wide --no-headers | grep -E "control-plane|bpf1" | awk -F " " '{print $6}');[ -n "$controller_node_ip" ];do sleep 1;done
kubectl taint nodes $(kubectl get nodes -o wide | grep control-plane | awk -F " " '{print $1}') node-role.kubernetes.io/control-plane:NoSchedule- > /dev/null 2>&1
kubectl get nodes -o wide

# 3. install cni(Calico v3.23.2)
kubectl apply -f calico.yaml

# 4. wait all pods ready
until pod_list=$(kubectl get pods -o wide -A --no-headers);[ -n "$pod_list" ];do sleep 1;done
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

