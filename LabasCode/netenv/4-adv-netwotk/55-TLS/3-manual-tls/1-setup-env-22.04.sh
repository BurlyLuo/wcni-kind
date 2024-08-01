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
    - sudo bash -c '{ echo "alias vi=\"vim\""; echo "alias ll=\"ls -lF\""; } >> ~/.bashrc'
    - sudo wget http://192.168.2.100/k3s/rzsz/rz -P /usr/bin/ && wget http://192.168.2.100/k3s/rzsz/sz -P /usr/bin/ && chmod +x /usr/bin/rz /usr/bin/sz
    - sudo wget -r -np -nH --cut-dirs=1 --directory-prefix="/root/" http://192.168.2.100/k3s/go/ && chmod +x "/root/go/install.sh" && /root/go/install.sh 
    - sudo find /root/go/ -name index.html -exec rm {} \;
EOF
done

openssl genrsa -out server.key 2048
openssl req -nodes -new -key server.key -subj '/CN=vm22040' -out server.csr
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt

mapfile -t ip_addresses < <(multipass list | grep vm2204[0-9] | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++)); do
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1
    scp -r server.crt server.key http-server.go https-server.go root@${ip_addresses[$ip_id]}:/root/ 
    echo "${ip_addresses[$ip_id]} vm2204$ip_id" >> /etc/hosts
done

