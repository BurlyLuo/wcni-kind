# Auther name: [Wei Luo]
# Mail address [olaf.luo@foxmail.com]
# Docs address [https://www.yuque.com/wei.luo]
# Bootcamp url [https://youdianzhishi.com/web/course/1041]
# Issue report [https://github.com/BurlyLuo/wcni-kind/issues or https://gitee.com/rowan-wcni/wcni-kind/issues]


# 1. setup k3s nodes
alias addk3svms='addk3svms-cluster() {
    echo "[*] Settingup k3s node..."
    if [ -z "$(kcli list vms | egrep k1\|k2\|k3)" ]; then
        kcli create vm -i k3s_compressed -P numcpus=6 -P memory=8192 -P disks=[50] -P rootpassword=hive -P nets="[{\"name\":\"vppdpdk5\",\"ip\":\"10.1.5.51\",\"netmask\":\"24\",\"gateway\":\"10.1.5.3\"},{\"name\":\"vppdpdk5\"},{\"name\":\"vppdpdk8\"},{\"name\":\"vppdpdk9\"}]" k1
        kcli create vm -i k3s_compressed -P numcpus=6 -P memory=8192 -P disks=[50] -P rootpassword=hive -P nets="[{\"name\":\"vppdpdk8\",\"ip\":\"10.1.8.52\",\"netmask\":\"24\",\"gateway\":\"10.1.8.3\"},{\"name\":\"vppdpdk5\"},{\"name\":\"vppdpdk8\"},{\"name\":\"vppdpdk9\"}]" k2; \
        kcli create vm -i k3s_compressed -P numcpus=6 -P memory=8192 -P disks=[50] -P rootpassword=hive -P nets="[{\"name\":\"vppdpdk8\",\"ip\":\"10.1.8.53\",\"netmask\":\"24\",\"gateway\":\"10.1.8.3\"},{\"name\":\"vppdpdk5\"},{\"name\":\"vppdpdk8\"},{\"name\":\"vppdpdk9\"}]" k3; \
    fi

    echo "[*] Initializing k3s cluster..."
    until ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=2 10.1.8.53 > /dev/null 2>&1 exit;do sleep 5;done
    echo "[*] Refreshing the environment..."
    delk3svms

    k3s_version=v1.27.3+k3s1
    master_ip="10.1.5.51"
    for ip in 10.1.5.51 10.1.8.52 10.1.8.53; do
        echo "[*] Loading k3s base image..."
        #ssh -o StrictHostKeyChecking=no $ip "wget -q -P /root/ http://192.168.2.100/http/k3s-airgap-images-amd64.tar ; docker load -i /root/k3s-airgap-images-amd64.tar"
        #ssh -o StrictHostKeyChecking=no $ip "wget -q -P /root/ http://192.168.2.100/http/k3s-uninstall.sh"
        echo "[*] Downloading cni bin file..."
        #ssh -o StrictHostKeyChecking=no $ip "mkdir -p /opt/cni/bin ; wget -q -r -np -nH --cut-dirs=3 --directory-prefix=/opt/cni/bin/ http://192.168.2.100/k3s/cni/bin/"
        #echo "[*] Setting socks5 PROXY..."
        #ssh -o StrictHostKeyChecking=no $ip "echo export HTTPS_PROXY=\"socks5://192.168.2.10:10808\" > ~/.bashrc && source ~/.bashrc"

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
                --print-command \
                --context=k3svms
        else
            k3sup join \
                --ip="$ip" \
                --user=root \
                --sudo \
                --k3s-version="$k3s_version" \
                --k3s-extra-args="--docker" \
                --server-ip="$master_ip" \
                --print-command \
                --server-user=root
        fi
        #echo "[*] Deleting socks5 PROXY..."
        ssh -o StrictHostKeyChecking=no $ip "env | grep PROXY"
        if [ $? == 0 ]; then
            ssh -o StrictHostKeyChecking=no $ip "sed -i \"/PROXY=/s/^/# /\" ~/.bashrc && source ~/.bashrc"
        fi
        ssh -o StrictHostKeyChecking=no "systemctl restart k3s > /dev/null 2>&1"
    done

}
addk3svms-cluster'

alias delk3svms='delk3svms-cluster() {
    for ip in 10.1.5.51 10.1.8.52 10.1.8.53; do
        echo "[*] Uninstalling k3s on $ip..."
        sed -i '1!d' /root/.ssh/known_hosts
        #scp -o StrictHostKeyChecking=no /root/wcni-kind/LabasCode/k8senv/vmenv/k3senv/k3s-uninstall.sh $ip:/root/ > /dev/null 2>&1
        ssh -o StrictHostKeyChecking=no $ip "{ bash /root/k3s-uninstall.sh; } > /dev/null 2>&1 ; rm -rf /etc/cni/net.d/*"
        #ssh -o StrictHostKeyChecking=no $ip "rm -rf /root/k3s-airgap-images-amd64.tar*"
    done

    echo "[*] Deleting kubectl configurations.."
    kubectl config get-clusters | grep -q "k3svm"
    if [ $? == 0 ]; then 
        kubectl config delete-cluster "k3svms"
        kubectl config delete-context "k3svms"
        kubectl config delete-user "k3svms"
    fi
    kubectl config unset current-context
}
delk3svms-cluster'


# 2. add iptables to let 10.1.5.x and 10.1.8.x can reach ext-network.
ssh 192.168.2.99 "iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -o brnet -j MASQUERADE"
# 2.1 node 10.1.5.51
for ip in 10.1.5.51 10.1.8.52 10.1.8.53; do
    ssh root@$ip "bash -c 'cat <<EOF>/etc/NetworkManager/conf.d/calico.conf
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:vxlan-v6.calico;interface-name:wireguard.cali;interface-name:wg-v6.cali
EOF
systemctl restart NetworkManager'"
done

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


[root@rowan> 09-calico-vpp]# all -owide 
NAMESPACE              NAME                                       READY   STATUS    RESTARTS      AGE   IP               NODE   NOMINATED NODE   READINESS GATES
calico-apiserver       calico-apiserver-748b4bb47c-m2mhm          1/1     Running   0             16h   172.18.195.139   k3     <none>           <none>
calico-apiserver       calico-apiserver-748b4bb47c-zmlqd          1/1     Running   0             16h   172.18.195.140   k3     <none>           <none>
calico-system          calico-kube-controllers-6bd8b6d8f6-x5dv6   1/1     Running   0             16h   172.18.195.137   k3     <none>           <none>
calico-system          calico-node-b9bq6                          1/1     Running   0             16h   10.1.8.52        k2     <none>           <none>
calico-system          calico-node-bd56m                          1/1     Running   0             16h   10.1.8.53        k3     <none>           <none>
calico-system          calico-node-rwk2v                          1/1     Running   0             16h   10.1.5.51        k1     <none>           <none>
calico-system          calico-typha-798f7dffd5-mtm86              1/1     Running   0             16h   10.1.8.52        k2     <none>           <none>
calico-system          calico-typha-798f7dffd5-wvsc2              1/1     Running   0             16h   10.1.8.53        k3     <none>           <none>
calico-system          csi-node-driver-99q4w                      2/2     Running   0             16h   172.18.105.130   k1     <none>           <none>
calico-system          csi-node-driver-hn29b                      2/2     Running   0             16h   172.18.195.141   k3     <none>           <none>
calico-system          csi-node-driver-ktgc7                      2/2     Running   0             16h   172.18.99.2      k2     <none>           <none>
calico-vpp-dataplane   calico-vpp-node-4zpgh                      2/2     Running   2 (15h ago)   16h   10.1.8.53        k3     <none>           <none>
calico-vpp-dataplane   calico-vpp-node-qrgzf                      2/2     Running   2 (15h ago)   16h   10.1.8.52        k2     <none>           <none>
calico-vpp-dataplane   calico-vpp-node-xqcmj                      2/2     Running   2 (15h ago)   16h   10.1.5.51        k1     <none>           <none>
default                wluo-gqkgx                                 1/1     Running   0             13h   172.18.99.3      k2     <none>           <none>
default                wluo-rk64v                                 1/1     Running   0             13h   172.18.195.143   k3     <none>           <none>
default                wluo-twg6m                                 1/1     Running   0             13h   172.18.105.131   k1     <none>           <none>
kube-system            coredns-77ccd57875-vth7m                   1/1     Running   0             24h   172.18.195.142   k3     <none>           <none>
kube-system            local-path-provisioner-957fdf8bc-wgq9x     1/1     Running   0             24h   172.18.195.138   k3     <none>           <none>
kube-system            metrics-server-648b5df564-8ksjp            1/1     Running   0             24h   172.18.195.136   k3     <none>           <none>
tigera-operator        tigera-operator-6489598d75-zjqs4           1/1     Running   0             16h   10.1.5.51        k1     <none>           <none>
[root@rowan> 09-calico-vpp]# 
