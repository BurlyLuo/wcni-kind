# 1. setup k3s nodes
kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'vppdpdk5','ip':'10.1.5.51','netmask':'24','gateway':'10.1.5.3'}]" k1
kcli create vm -i k3s_compressed -P numcpus=4 -P memory=4096 -P disks=[50] -P rootpassword=hive -P nets="[{'name':'vppdpdk8','ip':'10.1.8.52','netmask':'24','gateway':'10.1.8.3'}]" k2

# 2. add iptables to let 10.1.5.x and 10.1.8.x can reach ext-network.
ssh 192.168.2.99 "iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o brnet -j MASQUERADE"
# 2.1 node 10.1.5.11
cat <<EOF>/etc/NetworkManager/conf.d/calico.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:vxlan-v6.calico;interface-name:wireguard.cali;interface-name:wg-v6.cali
EOF

mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF>/etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=socks5://192.168.2.10:10808"
Environment="HTTPS_PROXY=socks5://192.168.2.10:10808"
Environment="NO_PROXY=localhost,127.0.0.1,192.168.0.0/16,10.1.5.11"
EOF
systemctl daemon-reload && systemctl restart docker

# 2.2 node 10.1.8.12
cat <<EOF>/etc/NetworkManager/conf.d/calico.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:vxlan-v6.calico;interface-name:wireguard.cali;interface-name:wg-v6.cali
EOF

mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF>/etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=socks5://192.168.2.10:10808"
Environment="HTTPS_PROXY=socks5://192.168.2.10:10808"
Environment="NO_PROXY=localhost,127.0.0.1,192.168.0.0/16,10.1.5.11"
EOF
systemctl daemon-reload && systemctl restart docker

# 3. init k3s cluster
# 3.1 addk3svm to setup a multi-node k3s cluster.
addk3svm-cluster()
{
    k3s_version=v1.27.3+k3s1
    master_ip="10.1.5.51"
    for ip in 10.1.5.51 10.1.8.52; do
        if [ "$ip" == "$master_ip" ]; then
            k3sup install \
                --ip="$master_ip" \
                --user=root \
                --merge \
                --sudo \
                --cluster \
                --k3s-version="$k3s_version" \
                --k3s-extra-args="--docker --flannel-backend=none --cluster-cidr=10.244.0.0/16 --disable-network-policy --disable traefik --disable servicelb --node-ip=$master_ip" \
                --local-path="$HOME/.kube/config" \
                --context=k3svm
        else
            k3sup join \
                --ip="$ip" \
                --user=root \
                --sudo \
                --k3s-version="$k3s_version" \
                --k3s-extra-args="--docker" \
                --server-ip="$master_ip" \
                --server-user=root
        fi
    done

}
addk3svm-cluster

# 3.2 delk3svm to destroy a multi-node k3s cluster.
delk3svm-cluster()
{
    for ip in 10.1.5.51 10.1.8.52; do
        echo "Uninstalling k3s on $ip..."
        sshpass -p hive ssh-copy-id -o StrictHostKeyChecking=no -p 22 root@"$ip" > /dev/null 2>&1 && ssh -o StrictHostKeyChecking=no $ip "bash -c "/root/k3s-uninstall.sh > /dev/null 2>&1""
        ssh -o StrictHostKeyChecking=no $ip "/root/rmvcontainers.sh > /dev/null 2>&1 ; rm -rf /etc/cni/net.d/*"
    done
    echo "Deleting kubectl configurations.."
    kubectl config delete-cluster "k3svm"
    kubectl config delete-context "k3svm"
    kubectl config delete-user "k3svm"
    kubectl config unset current-context
}
delk3svm-cluster

# 4. Install Calico-VPP mode
0. how to install the vpp based calico
   https://github.com/projectcalico/vpp-dataplane/issues/222
1. https://docs.tigera.io/calico/latest/operations/troubleshoot/troubleshooting#configure-networkmanager
2. kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/calico.yaml
3. curl -o calico-vpp.yaml https://raw.githubusercontent.com/projectcalico/vpp-dataplane/v3.29.0/yaml/generated/calico-vpp-nohuge.yaml  # replace the "interfaceName": "eth0" with default route interface name
4. kubectl create -f calico-vpp.yaml
5. kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
-6. kubectl create -f https://raw.githubusercontent.com/projectcalico/vpp-dataplane/v3.29.0/yaml/calico/installation-default.yaml
|
| installation-default.yaml[IPIPCrossSubnet mode]
[root@k3s1 ~]# cat installation-default.yaml 
# This section includes base Calico installation configuration.
# For more information, see: https://projectcalico.docs.tigera.io/master/reference/installation/api#operator.tigera.io/v1.Installation
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    linuxDataplane: VPP
    ipPools: 
    - cidr: 172.18.0.0/16
      encapsulation: IPIPCrossSubnet

---

# This section configures the Calico API server.
# For more information, see: https://projectcalico.docs.tigera.io/master/reference/installation/api#operator.tigera.io/v1.APIServer
apiVersion: operator.tigera.io/v1
kind: APIServer 
metadata: 
  name: default 
spec: {}

[root@k3s1 ~]#
[root@rowan> LabasCode]# all -o wide 
NAMESPACE              NAME                                       READY   STATUS    RESTARTS      AGE   IP             NODE   NOMINATED NODE   READINESS GATES
calico-apiserver       calico-apiserver-57b79cbdd8-vm8rh          1/1     Running   7 (19h ago)   19h   172.18.74.71   k3s2   <none>           <none>
calico-apiserver       calico-apiserver-57b79cbdd8-zljbf          1/1     Running   8 (74m ago)   19h   172.18.79.30   k3s1   <none>           <none>
calico-system          calico-kube-controllers-7c54f55647-nbfvp   1/1     Running   0             58m   172.18.74.73   k3s2   <none>           <none>
calico-system          calico-node-9wcfs                          1/1     Running   1 (19h ago)   19h   192.168.2.52   k3s2   <none>           <none>
calico-system          calico-node-cwqld                          1/1     Running   3 (63m ago)   19h   192.168.2.51   k3s1   <none>           <none>
calico-system          calico-typha-79d9cfbcff-nlspc              1/1     Running   3 (63m ago)   19h   192.168.2.51   k3s1   <none>           <none>
calico-system          csi-node-driver-2x98j                      2/2     Running   4 (74m ago)   19h   172.18.79.48   k3s1   <none>           <none>
calico-system          csi-node-driver-fbdwg                      2/2     Running   2 (19h ago)   19h   172.18.74.70   k3s2   <none>           <none>
calico-vpp-dataplane   calico-vpp-node-vwsnd                      2/2     Running   0             59m   192.168.2.51   k3s1   <none>           <none>
calico-vpp-dataplane   calico-vpp-node-wtmb8                      2/2     Running   0             59m   192.168.2.52   k3s2   <none>           <none>
default                wluo-b7hrg                                 1/1     Running   1 (19h ago)   19h   172.18.74.69   k3s2   <none>           <none>
default                wluo-zhgfq                                 1/1     Running   2 (74m ago)   19h   172.18.79.33   k3s1   <none>           <none>
kube-system            coredns-77ccd57875-482tr                   1/1     Running   8 (78m ago)   20h   172.18.79.34   k3s1   <none>           <none>
kube-system            local-path-provisioner-957fdf8bc-nb84b     1/1     Running   2 (74m ago)   20h   172.18.79.31   k3s1   <none>           <none>
kube-system            metrics-server-648b5df564-6268p            1/1     Running   9 (75m ago)   20h   172.18.79.32   k3s1   <none>           <none>
tigera-operator        tigera-operator-6489598d75-zm9jj           1/1     Running   0             58m   192.168.2.52   k3s2   <none>           <none>
[root@rowan> LabasCode]# 

