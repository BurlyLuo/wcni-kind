
kubectl create -f https://raw.githubusercontent.com/projectcalico/vpp-dataplane/v3.29.0/yaml/calico/installation-default.yaml

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
      encapsulation: VXLAN

---

# This section configures the Calico API server.
# For more information, see: https://projectcalico.docs.tigera.io/master/reference/installation/api#operator.tigera.io/v1.APIServer
apiVersion: operator.tigera.io/v1
kind: APIServer 
metadata: 
  name: default 
spec: {}

[root@k3s1 ~]# 

