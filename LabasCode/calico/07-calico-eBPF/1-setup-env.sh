#/bin/bash
set -v

# host version [22.04.3] https://fridge.ubuntu.com/2023/08/11/ubuntu-22-04-3-lts-released/
# multipass vr [1.15.1 ] https://canonical.com/multipass/install
# nettool imge [v1.1.11] docker pull burlyluo/nettool:latest
# k3sup  tools [0.13.7 ] https://github.com/alexellis/k3sup/releases/download/0.13.8/k3sup

# Auther name: [Wei Luo]
# Mail address [olaf.luo@foxmail.com]
# Docs address [https://www.yuque.com/wei.luo]
# Bootcamp url [https://youdianzhishi.com/web/course/1041]
# Issue report [https://github.com/BurlyLuo/wcni-kind/issues or https://gitee.com/rowan-wcni/wcni-kind/issues]

# 0. Install necessary tools
for tool in {multipass,k3sup}; do
  if command -v $tool &> /dev/null; then
    echo $tool is already there.
  else
    case $tool in
      multipass)
        command -v apt &> /dev/null && apt -y update && snap install multipass || { echo "ERROR: wget installation failed" && exit 1; }
        ;;
      k3sup)
        wget --tries=3 https://github.com/alexellis/k3sup/releases/download/0.13.8/k3sup -O /usr/bin/k3sup && chmod +x /usr/bin/k3sup || exit 1
        ;;
      *)
        echo "ERROR: Unknown tool, Pls check the spelling." && exit 1
        ;;
    esac
  fi
done

# 1. Deploy multipass vmk
for ((i=0; i<${1:-3}; i++))
do
  multipass launch 22.04 -n vmk"$i" -c 3 -m 3G -d 30G --cloud-init - <<EOF
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
mapfile -t ip_addresses < <(multipass list | grep -E 'vmk' | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++)); do
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1

    echo "${ip_addresses[$ip_id]} vmk$ip_id" >> /etc/hosts

    master_ip=${ip_addresses[0]}
    k3s_version="v1.27.3+k3s1"

    if [ $ip_id -eq 0 ]; then
        # --k3s-extra-args can refer: k3s server -h | grep flannel-backend
        k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=kpr
    else
        k3sup join --ip ${ip_addresses[$ip_id]} --user root --sudo --k3s-version=$k3s_version --server-ip $master_ip --server-user root
    fi
done

# 3. replace calico-bpf.yaml's KUBERNETES_SERVICE_HOST
KUBERNETES_SERVICE_HOST=`kubectl get nodes --selector=node-role.kubernetes.io/control-plane -o jsonpath='{$.items[*].status.addresses[?(@.type=="InternalIP")].address}'`
kubectl get nodes -owide
echo $KUBERNETES_SERVICE_HOST
sed -i "s/kubernetes_service_host: \".*\"/kubernetes_service_host: \"${KUBERNETES_SERVICE_HOST}\"/" calico-bpf.yaml

kubectl apply -f ./calico-bpf.yaml
kubectl wait --timeout=150s --for=condition=Ready=true pods --all -A

# 4. Enable calico bpf feature
calicoctl patch felixconfiguration default --patch='{"spec": {"bpfEnabled": true}}'
kubectl -nkube-system rollout restart ds/calico-node
kubectl -nkube-system wait --timeout=160s --for=condition=Ready=true pod -l k8s-app=calico-node
