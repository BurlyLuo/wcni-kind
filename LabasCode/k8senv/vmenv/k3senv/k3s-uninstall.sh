#!/bin/sh
set -v
[ $(id -u) -eq 0 ] || exec sudo $0 $@

/usr/local/bin/k3s-killall.sh

if command -v systemctl; then
    systemctl disable k3s
    systemctl reset-failed k3s
    systemctl daemon-reload
fi
if command -v rc-update; then
    rc-update delete k3s default
fi

rm -f /etc/systemd/system/k3s.service
rm -f /etc/systemd/system/k3s.service.env

#remove_uninstall() {
#    rm -f /usr/local/bin/k3s-uninstall.sh
#}
#trap remove_uninstall EXIT

if (ls /etc/systemd/system/k3s*.service || ls /etc/init.d/k3s*) >/dev/null 2>&1; then
    set +x; echo 'Additional k3s services installed, skipping uninstall of k3s'; set -x
fi

for cmd in kubectl crictl ctr; do
    if [ -L /usr/local/bin/$cmd ]; then
        rm -f /usr/local/bin/$cmd
    fi
done

rm -rf /etc/rancher/k3s
rm -rf /run/k3s
rm -rf /run/flannel
rm -rf /var/lib/rancher/k3s
rm -rf /var/lib/kubelet
#rm -f /usr/local/bin/k3s
#rm -f /usr/local/bin/k3s-killall.sh

#if type yum >/dev/null 2>&1; then
#    yum remove -y k3s-selinux
#    rm -f /etc/yum.repos.d/rancher-k3s-common*.repo
#elif type rpm-ostree >/dev/null 2>&1; then
#    rpm-ostree uninstall k3s-selinux
#    rm -f /etc/yum.repos.d/rancher-k3s-common*.repo
#elif type zypper >/dev/null 2>&1; then
#    uninstall_cmd="zypper remove -y k3s-selinux"
#    if [ "${TRANSACTIONAL_UPDATE=false}" != "true" ] && [ -x /usr/sbin/transactional-update ]; then
#        uninstall_cmd="transactional-update --no-selfupdate -d run $uninstall_cmd"
#    fi
#    $uninstall_cmd
#    rm -f /etc/zypp/repos.d/rancher-k3s-common*.repo
#fi

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

