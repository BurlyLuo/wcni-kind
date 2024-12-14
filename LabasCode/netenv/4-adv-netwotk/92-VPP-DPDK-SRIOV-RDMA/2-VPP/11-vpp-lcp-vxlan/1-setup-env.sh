kcli create vm -i  vpp-proto-bookworm -P numcpus=4 -P memory=4096 -P disks=[50] -P nets="[{'name':'brnet'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" lcp1

cat <<EOF>/etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      addresses: [192.168.2.71/24]
      gateway4: 192.168.2.1
      nameservers: 
        addresses: [192.168.2.1]
      optional: true
      accept-ra: true
      dhcp4: false
      dhcp6: true
EOF
netplan apply

scp -r ./71vm/* 192.168.2.71:/etc/vpp/ && ssh 192.168.2.71 "systemctl restart vpp"

kcli create vm -i  vpp-proto-bookworm -P numcpus=4 -P memory=4096 -P disks=[50] -P nets="[{'name':'brnet'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" lcp2

cat <<EOF>/etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      addresses: [192.168.2.72/24]
      gateway4: 192.168.2.1
      nameservers:
        addresses: [192.168.2.1]
      optional: true
      accept-ra: true
      dhcp4: false
      dhcp6: true
EOF
netplan apply

scp -r ./72vm/* 192.168.2.72:/etc/vpp/ && ssh 192.168.2.72 "systemctl restart vpp"


kcli create vm -i  ubuntu2204 -P memory=512 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.61','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P numcpus=1 -P cmds='[apt -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' ipng1

ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.2.61" >/dev/null 2>&1 && ssh -o StrictHostKeyChecking=no 192.168.2.61 "ip a a 10.1.5.11/24 dev ens4 && ip l s ens4 up"


kcli create vm -i  ubuntu2204 -P memory=512 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'brnet','ip':'192.168.2.62','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk9'}]" -P numcpus=1 -P cmds='[apt -y install net-tools pciutils wget lrzsz ; wget http://192.168.2.100/kvm/tools/lseth -P /usr/bin/ && chmod +x /usr/bin/lseth ; echo "TZ=Asia/Shanghai;export TZ" >> /etc/profile]' ipng2

ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.2.62" >/dev/null 2>&1 && ssh -o StrictHostKeyChecking=no 192.168.2.62 "ip a a 10.1.8.12/24 dev ens5 && ip l s ens5 up"

