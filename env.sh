#!/bin/bash
set -v
#1.Add alias
if [[ $(cat ~/.bashrc | grep cc | wc -l) -gt 0 ]];then echo "alias already exsits"
else
cat <<EOF>>~/.bashrc
alias wp="cd /root/wcni-kind"
alias gitc="git clone git@gitee.com:rowan-wcni/wcni-kind.git"
alias k="kubectl"
alias dip="kubectl get node -o wide"
alias kk="kubectl -nkube-system"
alias ds="docker ps"
alias cc="kubectl config get-contexts" 
alias sc="kubectl config use-context $1" 
alias lo="docker exec -it $1 $2"
alias all="kubectl get pods -A"
alias cls="kind get clusters $1"
alias cld="kind delete clusters $1"
EOF
fi

source ~/.bashrc > /dev/null 2>&1


#while true;do if [[ $(kubectl wait --for=condition=Ready nodes --all | grep met | wc -l) -eq $(kubectl get nodes -o name | wc -l) ]];then break;else sleep 1;fi;done


apt install sshpass >/dev/null 2>&1
for ip in {192.168.2.71,192.168.2.72,192.168.2.73}
do
  sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no root@$ip -p 22 >/dev/null 2>&1
done

ssh 192.168.2.71 '
echo "
network:
  version: 2
  ethernets:
    ens160:
      addresses:
      - 192.168.2.71/24
      gateway4: 192.168.2.1
      nameservers:
        addresses:
        - 192.168.2.1
        search: []
" >/etc/netplan/01-network-manager-all.yaml && systemctl stop NetworkManager && systemctl disable NetworkManager && netplan apply'

ssh 192.168.2.72 '
echo "
network:
  version: 2
  ethernets:
    ens160:
      addresses:
      - 192.168.2.72/24
      gateway4: 192.168.2.1
      nameservers:
        addresses:
        - 192.168.2.1
        search: []
" >/etc/netplan/01-network-manager-all.yaml && systemctl stop NetworkManager && systemctl disable NetworkManager && netplan apply'


ssh 192.168.2.73 '
echo "
network:
  version: 2
  ethernets:
    ens160:
      addresses:
      - 192.168.2.73/24
      gateway4: 192.168.2.1
      nameservers:
        addresses:
        - 192.168.2.1
        search: []
" >/etc/netplan/01-network-manager-all.yaml && systemctl stop NetworkManager && systemctl disable NetworkManager && netplan apply'

