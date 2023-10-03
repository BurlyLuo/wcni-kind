

wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2
wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2


apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
apt install guestfish

virt-customize -a /data/centosx.qcow2 --root-password password:hive
virt-install --os-variant list


virt-install --name vpp0 --memory 6144  --cpu host-model --vcpus=6 --disk /data/centosvpp0.qcow2,device=disk,bus=virtio --disk size=10 --os-variant centos7 --virt-type kvm --graphics none --network=bridge=brnat,model=virtio --network=bridge=brvpp0,model=virtio --network=bridge=brvpp1,model=virtio --import

master_ip=192.168.245.144
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@$master_ip > /dev/null 2>&1

k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=vpp

yum -y install wget
mkdir -p /etc/rancher/k3s/ && wget http://192.168.2.100/k3s/registries.yaml -P /etc/rancher/k3s/
wget -r -np -nH --cut-dirs=3 --directory-prefix=/opt/cni/bin/ http://192.168.2.100/k3s/cni/bin/ && find /opt/cni/bin/ -type f | xargs chmod +x
bash -c '{ echo "alias all=\"kubectl get pods -A\""; echo "alias k=\"kubectl\""; echo "alias kk=\"kubectl -nkube-system\"" ; } >> ~/.bashrc'





virt-install --name vpp1 --memory 4096  --cpu host-model --vcpus=4 --disk /data/centosvpp1.qcow2,device=disk,bus=virtio --disk size=10 --os-variant centos7 --virt-type kvm --graphics none --network=bridge=brnat,model=virtio --network=bridge=brvpp0,model=virtio --network=bridge=brvpp1,model=virtio --import







virt-install --name vpp1 --memory 4096  --cpu host-model --vcpus=6 --disk /data/centosvpp.qcow2,device=disk,bus=virtio --disk size=10 --os-variant centos7 --virt-type kvm --graphics none --network=bridge=brnat,model=virtio --network=network=vpp0,model=virtio --network=bridge=brvpp1,model=virtio --import

master_ip=192.168.245.145
sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@$master_ip > /dev/null 2>&1

k3sup install --ip=$master_ip --user=root --merge --sudo --cluster --k3s-version=v1.27.3+k3s1 --k3s-extra-args "--flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$master_ip" --local-path $HOME/.kube/config --context=vppx
 
