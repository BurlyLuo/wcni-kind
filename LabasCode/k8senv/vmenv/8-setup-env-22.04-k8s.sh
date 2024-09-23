#/bin/bash
set -v

if [ ${1:-1} -ge 2 ]; then cpu=2;mem=2G;else cpu=8;mem=8G;fi

for ((i=0; i<${1:-1}; i++))
do
  multipass launch 22.04 -n vm2204"$i" -c $cpu -m $mem -d 30G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config.d/*.conf
    - sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh
    - sudo bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias cls=\"kind get clusters\""; echo "alias cld=\"kind delete clusters\""; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias lo=\"docker exec -it\"";echo "alias ds=\"docker ps|grep -v registry\"";echo "alias dip=\"kubectl get nodes -o wide\""; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias vi=\"vim\""; echo "alias ll=\"ls -lF\""; } >> ~/.bashrc'
    - sudo wget http://192.168.2.100/k3s/cilium-related/helm -P /usr/bin/ && chmod +x /usr/bin/helm
    - sudo wget http://192.168.2.100/k3s/cilium-related/kubectl -P /usr/bin/ && chmod +x /usr/bin/kubectl
    - sudo wget http://192.168.2.100/k3s/cilium-related/kind -P /usr/bin/ && chmod +x /usr/bin/kind
    - sudo wget http://192.168.2.100/k3s/rzsz/rz -P /usr/bin/ && wget http://192.168.2.100/k3s/rzsz/sz -P /usr/bin/ && chmod +x /usr/bin/rz /usr/bin/sz
    - sudo mkdir -p /root/env/docker/ && wget -r -np -nH --cut-dirs=3 --directory-prefix=/root/env/docker/ http://192.168.2.100/k3s/cilium-related/docker/
    - sudo dpkg -i /root/env/docker/*.deb
    - sudo wget http://192.168.2.100/k3s/cilium-related/daemon.json -P /etc/docker/
    - sudo systemctl daemon-reload && systemctl restart docker && systemctl enable docker
    - sudo docker pull 192.168.2.100:5000/kindest/node:v1.27.3 && docker tag 192.168.2.100:5000/kindest/node:v1.27.3 kindest/node:v1.27.3
    - sudo curl -L http://192.168.2.100/http/k3s-airgap-images-amd64.tar | sudo docker load
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix="/root/" http://192.168.2.100/k3s/vmenv/mmenv/ubuntu2204/ && chmod +x "/root/ubuntu2204/pwru.sh" 
    - sudo find /root/ubuntu2204/ -name index.html -exec rm {} \;
EOF
done

mapfile -t ip_addresses < <(multipass list | grep vm2204[0-9] | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++)); do
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1
    echo "${ip_addresses[$ip_id]} vm2204$ip_id" >> /etc/hosts
    master_ip=${ip_addresses[$ip_id]}
    k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable-kube-proxy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=2204ctx
    ssh root@${master_ip} "mkdir -p $HOME/.kube && cp -r /etc/rancher/k3s/k3s.yaml $HOME/.kube/config"
done
