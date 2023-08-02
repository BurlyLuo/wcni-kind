#/bin/bash
set -v

# 1. Deploy multipass vm
multipass stop --all;multipass delete --purge --all;{ sed -i '1!d' /root/.ssh/known_hosts && sed -i '/^10\.241\.245\./d' /etc/hosts; } > /dev/null 2>&1

for ((i=0; i<${3:-3}; i++))
do
  multipass launch 22.04 -n vm"$i" -c 2 -m 2G -d 10G --cloud-init - <<EOF
  # cloud-config
  runcmd:
    - sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    - sudo echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
    - echo 'root:hive' | sudo chpasswd
    - sudo systemctl restart sshd
EOF
done

# 2. prep env[ubuntu 22.04]
mapfile -t ip_addresses < <(multipass list | grep -E 'vm' | awk '{print $3}')

for ((ip_id=0; ip_id<${#ip_addresses[@]}; ip_id++));do sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@${ip_addresses[$ip_id]} > /dev/null 2>&1;done

multipass list | grep vm | grep "10.241.245." | awk -F " " '{print $3, $1}' >> /etc/hosts >> /etc/hosts

k3sup install --ip=${ip_addresses[0]} --user=root --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=${ip_addresses[0]}" --local-path $HOME/.kube/config --context=k3s-ha

k3sup join --ip ${ip_addresses[1]} --user root --sudo --k3s-version=v1.27.3+k3s1 --server --server-ip ${ip_addresses[0]} --server-user root --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=${ip_addresses[1]}"

k3sup join --ip ${ip_addresses[2]} --user root --sudo --k3s-version=v1.27.3+k3s1 --server --server-ip ${ip_addresses[0]} --server-user root --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=${ip_addresses[2]}"

