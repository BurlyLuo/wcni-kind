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

