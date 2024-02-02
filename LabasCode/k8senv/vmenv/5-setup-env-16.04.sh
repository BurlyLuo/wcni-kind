#/bin/bash
set -v

if [ ${1:-1} -ge 2 ]; then cpu=2;mem=2G;else cpu=8;mem=8G;fi

for ((i=0; i<${1:-1}; i++))
do
  multipass launch 16.04 -n vm1604"$i" -c $cpu -m $mem -d 30G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config 
    - sudo sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh
    - sudo bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias cls=\"kind get clusters\""; echo "alias cld=\"kind delete clusters\""; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias lo=\"docker exec -it\"";echo "alias ds=\"docker ps|grep -v registry\"";echo "alias dip=\"kubectl get nodes -o wide\""; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias vi=\"vim\""; echo "alias ll=\"ls -lF\""; } >> ~/.bashrc'
    - sudo wget http://192.168.2.100/k3s/cilium-related/helm -P /usr/bin/ && chmod +x /usr/bin/helm
    - sudo wget http://192.168.2.100/k3s/cilium-related/kind -P /usr/bin/ && chmod +x /usr/bin/kind
    - sudo wget http://192.168.2.100/k3s/vmenv/mmenv/ubuntu1604/minikube/kubeinit/minikube -P /usr/bin/ && chmod +x /usr/bin/minikube
    - sudo wget http://192.168.2.100/k3s/vmenv/mmenv/ubuntu1604/minikube/kubeinit/kubectl -P /usr/bin/ && chmod +x /usr/bin/kubectl
    - sudo wget http://192.168.2.100/k3s/rzsz/rz -P /usr/bin/ && wget http://192.168.2.100/k3s/rzsz/sz -P /usr/bin/ && chmod +x /usr/bin/rz /usr/bin/sz
    - sudo mkdir -p /var/lib/minikube/binaries/v1.20.15/
    - sudo wget -r -np -nH --cut-dirs=6 --directory-prefix="/var/lib/minikube/binaries/v1.20.15/" http://192.168.2.100/k3s/vmenv/mmenv/ubuntu1604/minikube/kubeinit/
    - sudo find /var/lib/minikube/binaries/v1.20.15/ -type f -exec chmod +x {} \;
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix="/root/" http://192.168.2.100/k3s/vmenv/mmenv/ubuntu1604/
    - sudo dpkg -i /root/ubuntu1604/minikube/docker/*.deb && dpkg -i /root/ubuntu1604/minikube/tools/conntrack/*.deb
    - sudo rm -rf /etc/docker/daemon.json > /dev/null 2>&1 && wget http://192.168.2.100/k3s/vmenv/mmenv/ubuntu1604/minikube/docker/daemon.json -P /etc/docker/
    - sudo systemctl daemon-reload && systemctl restart docker && systemctl enable docker
    - sudo docker pull 192.168.2.100:5000/kindest/node:v1.27.3 && docker tag 192.168.2.100:5000/kindest/node:v1.27.3 kindest/node:v1.27.3
    - sudo find /root/ubuntu1604/ -name index.html -exec rm {} \;
    - sudo docker load -i /root/ubuntu1604/minikube/kubeinit/metrics-server.tgz && mkdir -p /opt/cni/bin/
    - sudo wget -r -np -nH --cut-dirs=3 --directory-prefix=/opt/cni/bin/ http://192.168.2.100/k3s/cni/bin/ && find /opt/cni/bin/ -type f | xargs chmod +x
    - sudo mkdir -p /etc/cni/net.d && minikube start --image-mirror-country='cn' --kubernetes-version=v1.20.15 --vm-driver=none --force --cni=flannel && sleep 15
    - sudo bash -c 'echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> $HOME/.bashrc'
    - sudo bash -c "export KUBECONFIG=/etc/kubernetes/admin.conf && kubectl apply -f /root/ubuntu1604/minikube/kubeinit/metrics-server.yaml"
    - sudo rm -rf /etc/docker/daemon.json && wget http://192.168.2.100/k3s/vmenv/mmenv/ubuntu1604/minikube/docker/daemon.json -P /etc/docker/
    - sudo systemctl daemon-reload && systemctl restart docker && systemctl enable docker
    - sudo wget http://192.168.2.100/k3s/vmenv/mmenv/ubuntu1604/minikube/cni.yaml -P /root/
EOF
done

mapfile -t ip_addresses < <(multipass list | grep vm1604[0-9] | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++)); do
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1
    echo "${ip_addresses[$ip_id]} vm1604$ip_id" >> /etc/hosts
done

