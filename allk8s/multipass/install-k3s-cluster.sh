#/bin/bash
# 1. Deploy vm
multipass launch 20.04 -n k3s-master0 -c 2 -m 2G -d 10G --cloud-init k3s-master0.config.yaml
multipass launch 20.04 -n k3s-worker1 -c 2 -m 1G -d 10G --cloud-init k3s-worker1.config.yaml
multipass launch 20.04 -n k3s-worker2 -c 2 -m 1G -d 10G --cloud-init k3s-worker2.config.yaml

# 2. prep env
for ip in $(multipass list | awk -F " " '{if (NR>1){print $3}}')
do  
    echo $ipaddr
    sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no ubuntu@$ip -p 22
done    

# 3. Deploy k3s cluster
k3s_master0_ip=`(multipass list | grep master0 | awk -F " " '{print $3}')`
k3s_worker1_ip=`(multipass list | grep worker1 | awk -F " " '{print $3}')`
k3s_worker2_ip=`(multipass list | grep worker1 | awk -F " " '{print $3}')`

k3sup install \
  --ip=$k3s_master0_ip \
  --user=ubuntu \
  --sudo \
  --cluster \
  --k3s-version=v1.23.4+k3s1 \
  --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$k3s_master0_ip" \
  --local-path $HOME/.kube/config \
  --context=k3s-ha


k3sup join \
  --ip $k3s_worker1_ip \
  --user ubuntu \
  --sudo \
  --k3s-version=v1.23.4+k3s1 \
  --server \
  --server-ip $k3s_master0_ip \
  --server-user ubuntu \
  --sudo \
  --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$k3s_worker1_ip"


k3sup join \
  --ip $k3s_worker2_ip \
  --user ubuntu \
  --sudo \
  --k3s-version=v1.23.4+k3s1 \
  --server \
  --server-ip $k3s_master0_ip \
  --server-user ubuntu \
  --sudo \
  --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.10.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$k3s_worker2_ip"
  
