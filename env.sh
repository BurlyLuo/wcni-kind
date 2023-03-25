#!/bin/bash
set -v
#1.Add alias
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
alias 1234="kubectl get pods -A"
EOF

source ~/.bashrc > /dev/null 2>&1


while true;do if [[ $(kubectl wait --for=condition=Ready nodes --all | grep met | wc -l) -eq $(kubectl get nodes -o name | wc -l) ]];then break;else sleep 1;fi;done

