#!/bin/bash
set -v

# 1. Topo about kvm host
cat <<EOF
*****************************************************************
# lsb_release -a 
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy
*****************************************************************
# KinD topo:
             vpp-192.168.2.71            vpp-192.168.2.72
                   kvm_71----HOME_LAB_VM----kvm_72
                                  |
                   [win-x][kvm-host][Bridge Network]
                            192.168.2.1/24
                                  |
                  192.168.2.10/24[Client]
*****************************************************************
EOF

# 2. Check arch about the environment
if [[ $(uname -m) != "x86_64" ]]; then
  echo "ERROR: Only support x86_64 system."
  echo "Current arch: $(uname -m)"
  exit 1
fi

# 3. Check vm distro and version
readarray -t vm < <(grep -Ew 'VERSION_ID|ID' /etc/os-release | cut -d= -f2 | tr -d '"')
if [ "${vm[0]}" != "22.04" ] && [ "${vm[1]}" != "ubuntu" ]; then
  echo "ERROR: This script only support Ubuntu2204."
  exit 1
fi

# 4. Check the run-user 
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root."
  exit 1
fi

# 5. Install necessary tools
for tool in {curl,kvm-ok,libvirtd,kcli,brctl,sshpass}; do
  if command -v $tool &> /dev/null; then
    echo "$tool is already installed!"
  else
    case $tool in
      curl)
        command -v apt &> /dev/null && apt -y update && apt -y install curl || { echo "ERROR: curl install failed" && exit 1; }
        ;;
      kvm-ok)
        apt -y install qemu-system-x86 qemu-kvm virt-manager || { echo "ERROR: kvm-utils install failed" && exit 1; }
        ;;
      libvirtd)
        apt -y install libvirt-daemon-system libvirt-clients virtinst guestfish || { echo "ERROR: libvirtd install failed" && exit 1; }
        systemctl enable libvirtd && usermod -aG qemu,libvirt $(id -un) && newgrp libvirt || { echo "ERROR: libvirtd init failed" && exit 1; }
        ;;
      kcli)
        curl https://raw.githubusercontent.com/karmab/kcli/main/install.sh | sudo bash || { echo "ERROR: kcli install failed" && exit 1; }
        ;;
      brctl)
        command -v apt &> /dev/null && apt -y update && apt -y install bridge-utils || { echo "ERROR: bridge-utils install failed" && exit 1; }
        ;;
      sshpass)
        apt -y install sshpass || { echo "ERROR: sshpass install failed" && exit 1; }
        ;;
      *)
        echo "ERROR: Unknown tool, Pls check the spelling." && exit 1
        ;;
    esac
  fi
done

# 6. Check linux bridges
readarray -t br < <(brctl show | grep -E 'vppdpdk[589]' | awk '{print $1}')
if [[ "${br[0]}" != "vppdpdk5" ]] && [[ "${br[1]}" != "vppdpdk8" ]] && [[ "${br[2]}" != "vppdpdk9" ]]; then
    echo "ERROR: Please create linux bridge: vppdpdk5,vppdpdk8,vppdpdk9."
fi

# 7. Check vpp image
image_dir=/var/lib/libvirt/images/
if [[ $(ls $image_dir | grep -E '^ipng7[12]$' | wc -l) -ne 2 ]]; then
    rm -rf "$image_dir/ipng7"{1,2}
    for image in ipng71.tgz ipng72.tgz; do
        wget -q --show-progress -P "$image_dir" https://github.com/BurlyLuo/wcni-kind/releases/download/ipng/$image && tar -xzf "$image_dir/$image" -C "$image_dir" || { echo "Download or extraction failed"; exit 1; }
    done
    if [[ $(ls $image_dir | grep -E '^ipng7[12]$' | wc -l) -ne 2 ]]; then 
        echo "ERROR: The ipng71 and ipng72 is not there"
        exit
    fi
fi
if [ $(iptables-save | grep "10.1.0.0/16" | wc -l) == 0 ]; then
  iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o brnet -j MASQUERADE
fi

# 7. Install kvm vm
kcli delete vm 192.168.2.71 192.168.2.72 -y > /dev/null 2>&1 
for ip in 192.168.2.71 192.168.2.72; do
    id=$(echo $ip | awk -F "." '{print $NF}')
    kcli create vm -i ipng$id -P numcpus=4 -P memory=4096 -P disks=[50] -P nets="[{'name':'brnet','ip':'$ip','netmask':'24','gateway':'192.168.2.1'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk5'},{'name':'vppdpdk8'},{'name':'vppdpdk8'},{'name':'vppdpdk9'},{'name':'vppdpdk9'}]" $ip
done

# 8. List vpp vms
set +v
vms_list=$(kcli list vms | grep ipng | grep 192.168.2.7)
echo "+--------------+--------+---------------+--------------------+-------+--------------------+"
echo "|     Name     | Status |       Ip      |       Source       |  Plan |      Profile       |"
echo "+--------------+--------+---------------+--------------------+-------+--------------------+"
echo "${vms_list}"
echo "+--------------+--------+---------------+--------------------+-------+--------------------+"
