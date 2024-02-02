#/bin/bash
set -v
for ((i=0; i<${1:-1}; i++))
do
  multipass launch 23.04 -n vm"$i" -c 8 -m 8G -d 30G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config.d/*.conf
    - sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && echo 'root:hive' | sudo chpasswd && systemctl restart ssh
    - sudo bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias cls=\"kind get clusters \""; echo "alias cld=\"kind delete clusters \""; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias lo=\"docker exec -it \""; echo "alias ds=\"docker ps | grep -v registry\""; } >> ~/.bashrc'
    - sudo bash -c '{ echo "alias vi=\"vim\""; echo "alias ll=\"ls -lF\""; } >> ~/.bashrc'
    - sudo wget http://192.168.2.100/k3s/cilium-related/helm -P /usr/bin/ && chmod +x /usr/bin/helm
    - sudo wget http://192.168.2.100/k3s/cilium-related/kubectl -P /usr/bin/ && chmod +x /usr/bin/kubectl
    - sudo wget http://192.168.2.100/k3s/cilium-related/kind -P /usr/bin/ && chmod +x /usr/bin/kind
    - sudo mkdir -p /root/env/kernel/ && wget -r -np -nH --cut-dirs=3 --directory-prefix=/root/env/kernel/ http://192.168.2.100/k3s/cilium-related/6.4-kernel/
    - sudo dpkg -i /root/env/kernel/*.deb
    - sudo mkdir -p /root/env/docker/ && wget -r -np -nH --cut-dirs=3 --directory-prefix=/root/env/docker/ http://192.168.2.100/k3s/cilium-related/docker/
    - sudo dpkg -i /root/env/docker/*.deb
    - sudo wget http://192.168.2.100/k3s/cilium-related/daemon.json -P /etc/docker/
    - sudo systemctl daemon-reload && systemctl restart docker && systemctl enable docker
    - sudo docker pull 192.168.2.100:5000/kindest:v1.27.3 && docker tag 192.168.2.100:5000/kindest:v1.27.3 kindest/node:v1.27.3
    - sudo reboot
EOF
done

ip_host=$(multipass list | grep vm[0-9] | awk -F " " '{print $3,$1}')
echo $ip_host >> /etc/hosts
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@$(echo $ip_host | awk -F " " '{print $1}') > /dev/null 2>&1
scp -r ./kindenv root@$(echo $ip_host | awk -F " " '{print $1}'):/root/

