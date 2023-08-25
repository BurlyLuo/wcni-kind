.
├── allk8s
│   ├── 0-Docs
│   │   ├── aliyun-k8s.tgz
│   │   ├── Docker容器你需要知道的 - Mr.Ye Blog (12_16_2022 9_04_16 PM).html
│   │   └── 【译】Docker 和子进程“僵尸化”问题 (12_16_2022 9_23_53 PM).html
│   ├── 1-Docker-env
│   │   └── 1-userguide.sh
│   ├── multipass
│   │   ├── 1-setup-env.sh
│   │   ├── 2-10M.yaml
│   │   ├── 3-test-bandwidth.sh
│   │   └── cni.yaml
│   ├── network
│   │   ├── 0-env-prep
│   │   │   └── 0-how-to-learn-k8s-CNI
│   │   │       └── 工程师如何明白的做事情.tgz
│   │   └── prepcni
│   │       └── ppt
│   │           ├── 01.Kubernetes Environment Preparation.pdf
│   │           └── 01.Kubernetes Environment Preparation.pptx
│   └── platform
│       └── daemon.json
├── calico
│   ├── 1-kind-calico-ipip
│   │   ├── 1-setup-env.sh
│   │   ├── 2-datapath
│   │   │   ├── 1-proxy-arp.datapath
│   │   │   ├── 2-ipip.datapath
│   │   │   ├── calico-ipip.datapath
│   │   │   ├── calico-ipip-ens160.cap
│   │   │   ├── calico-ipip-eth0.cap
│   │   │   └── calico-ipip-tunl0.cap
│   │   ├── 3-reference
│   │   │   └── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   ├── 2-kind-calico-ipip-crosssubnet
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 3-install-calico-ipip-crosssubnet.sh
│   │   ├── 4-datapath
│   │   │   ├── calico-ipip.datapath
│   │   │   ├── calico-ipip-ens160.cap
│   │   │   ├── calico-ipip-eth0.cap
│   │   │   └── calico-ipip-tunl0.cap
│   │   ├── 5-gc-resource.sh
│   │   ├── 6-reference
│   │   │   ├── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   │   └── Overlay networking (12_5_2022 3_33_25 PM).html
│   │   ├── calico.yaml
│   │   ├── clab-calico-ipip-crosssubnet
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yml.bak
│   │   ├── cni.yaml
│   │   └── startup-conf
│   │       ├── gw0-boot.cfg
│   │       └── gw0.cfg
│   ├── 3-kind-calico-vxlan
│   │   ├── 1-setup-env.sh
│   │   ├── 2-datapath
│   │   │   ├── calico-vxlan.datapath
│   │   │   └── default-ipv4-ippool.yaml
│   │   ├── 3-reference
│   │   │   ├── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   │   ├── 2-VxLAN vs IPIP.png
│   │   │   └── 3-Migrate a Kubernetes cluster from flannel_Canal to Calico (11_13_2022 2_27_26 PM).html
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   ├── 4-kind-calico-vxlan-crosssubnet
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 3-install-calico-vxlan-crosssubnet.sh
│   │   ├── 4-datapath
│   │   │   ├── calico-ipip.datapath
│   │   │   ├── calico-ipip-ens160.cap
│   │   │   ├── calico-ipip-eth0.cap
│   │   │   └── calico-ipip-tunl0.cap
│   │   ├── 5-gc-resource.sh
│   │   ├── 6-reference
│   │   │   └── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   ├── calico.yaml
│   │   ├── clab-calico-vxlan-crosssubnet
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yml.bak
│   │   ├── cni.yaml
│   │   └── startup-conf
│   │       ├── gw0-boot.cfg
│   │       └── gw0.cfg
│   ├── 5-kind-calico-fullmesh
│   │   ├── 1-setup-env.sh
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   ├── 6-kind-calico-bgp-rr
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 3-prep-calico-bgp.sh
│   │   ├── 4-enable-adv-service.sh
│   │   ├── 5-datapath
│   │   │   └── calico-bgp-rr.datapath
│   │   ├── 6-gc-resource.sh
│   │   ├── 7-reference
│   │   │   ├── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   │   └── Calico BGP Topo.png
│   │   ├── calico.yaml
│   │   ├── clab-calico-bgp-rr
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   ├── .tls
│   │   │   │   └── ca
│   │   │   │       ├── ca.key
│   │   │   │       └── ca.pem
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yaml.bak
│   │   ├── cni.yaml
│   │   └── startup-conf
│   │       ├── leaf0-boot.cfg
│   │       ├── leaf1-boot.cfg
│   │       ├── spine0-boot.cfg
│   │       └── spine1-boot.cfg
│   ├── a-kind-calico-clusterip
│   │   ├── 1-setup-env.sh
│   │   ├── 2-datapath
│   │   │   ├── datapath-clusterip
│   │   │   ├── kube-proxy-cluster-ip.svg
│   │   │   ├── Node-calico-ipip-control-plane.cap
│   │   │   └── Node-calico-ipip-worker-Pod-wluo-6pdtj.cap
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   ├── b-kind-calico-nodeport
│   │   ├── 1-setup-env.sh
│   │   ├── 2-datapath
│   │   │   ├── datapath-nodePort
│   │   │   ├── kube-proxy-node-port.svg
│   │   │   ├── Node-calico-ipip-control-plane-nodeport.cap
│   │   │   └── Node-calico-ipip-worker-Pod-wluo-6pdtj-nodeport.cap
│   │   ├── 3-reference
│   │   │   └── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   ├── c-kind-calico-load-balancer
│   │   ├── 1-setup-env.sh
│   │   ├── 2-metallb
│   │   │   ├── 1-metallb.yaml
│   │   │   └── 2-metallb-l2-config.yaml
│   │   ├── 3-test.sh
│   │   ├── 4-datapath
│   │   │   └── kube-proxy-load-balancer.svg
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   ├── d-kind-calico-adv-service-ip
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 3-prep-calico-bgp.sh
│   │   ├── 4-enable-adv-service.sh
│   │   ├── 5-datapath
│   │   │   └── calico-bgp-rr.datapath
│   │   ├── 6-gc-resource.sh
│   │   ├── 7-reference
│   │   │   ├── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   │   └── Calico BGP Topo.png
│   │   ├── calico.yaml
│   │   ├── clab-calico-bgp-rr
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── cni.yaml
│   │   └── startup-conf
│   │       ├── leaf0-boot.cfg
│   │       ├── leaf0.cfg
│   │       ├── leaf1-boot.cfg
│   │       ├── leaf1.cfg
│   │       ├── spine0-boot.cfg
│   │       ├── spine0.cfg
│   │       ├── spine1-boot.cfg
│   │       └── spine1.cfg
│   ├── e-kind-calico-externalTrafficPolicy-local
│   │   ├── 1-setup-env.sh
│   │   ├── 2-gc-resource.sh
│   │   ├── 3-datapath
│   │   │   ├── datapath
│   │   │   └── kube-proxy-service-local.svg
│   │   ├── 4-reference
│   │   │   └── 1-路由条目的意义_51CTO博客_路由条目.html
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   ├── f-kind-calico-eBPF-native-svc-handling
│   │   ├── 1-setup-env.sh
│   │   ├── 2-enable-dsr.sh
│   │   ├── 3-datapath
│   │   │   ├── calico-native-service-handling.svg
│   │   │   ├── Hands on with Calico’s eBPF data plane native service handling (12_12_2022 8_38_48 PM).html
│   │   │   └── Introducing the Calico eBPF dataplane (12_12_2022 8_38_32 PM).html
│   │   ├── calico.yaml
│   │   └── cni.yaml
│   └── g-kind-calico-flannel-canal-vxlan
│       ├── 1-setup-env.sh
│       ├── canal.yaml
│       └── cni.yaml
├── cilium
│   ├── 0-cilium-install-prep
│   │   ├── 1-kind-cilium-vxlan-with-kubeproxy
│   │   │   └── 1-setup-env.sh
│   │   ├── 2-kind-cilium-native-routing-with-kubeproxy
│   │   │   └── 1-setup-env.sh
│   │   ├── 3-kind-cilium-vxlan-without-kubeproxy
│   │   │   ├── 1-setup-env.sh
│   │   │   └── cni.yaml
│   │   ├── 4-kind-cilium-native-routing-without-kubeproxy
│   │   │   ├── 1-setup-env.sh
│   │   │   └── cni.yaml
│   │   ├── 5-kind-cilium-vxlan-eBPF-Host-Routing
│   │   │   ├── 1-setup-env.sh
│   │   │   └── cni.yaml
│   │   ├── 6-kind-cilium-native-routing-eBPF-Host-Routing
│   │   │   ├── 1-setup-env.sh
│   │   │   └── cni.yaml
│   │   └── cilium-1.12.0.tgz
│   ├── 1-cilium-native-routing-eBPF-Host-Routing
│   │   ├── 1-setup-env.sh
│   │   ├── 2-deploy-svc-testpod.sh
│   │   ├── 3-gc-resources.sh
│   │   └── 4-datapath
│   │       └── cilium-native-routing.datapath
│   ├── 2-cilium-vxlan-eBPF-Host-Routing
│   │   ├── 1-setup-env.sh
│   │   └── cni.yaml
│   ├── 4-cilium-native-routing-eBPF-Host-Routing-dsr
│   │   ├── 0-cilium-dsr-requirements
│   │   ├── 1-setup-cilium-dsr.sh
│   │   ├── 3-datapath
│   │   │   ├── dsr_71_ens160.cap
│   │   │   └── dsr.datapath
│   │   ├── 4-cilium-client-source-ip-preservation
│   │   │   └── 0-compare-kind_env-bare_env
│   │   │       ├── 0-ReadME.txt
│   │   │       ├── 1-externalTrafficPolicy-Local.datapath
│   │   │       └── 2-externalTrafficPolicy-Cluster.datapath
│   │   ├── 4-reference
│   │   │   └── Cilium 1.7_ Hubble UI, Cluster-wide Network Policies, eBPF-based Direct Server Return, TLS visibility, New eBPF Go Library, ... (11_21_2022 10_24_36 PM).html
│   │   └── cilium-dsr.yaml
│   ├── 8-cilium-native-routing-with-kubeproxy-ipsec
│   │   ├── 1-setup-env.sh
│   │   ├── cni.yaml
│   │   └── ens160.cap
│   ├── 9-cilium-vxlan-with-kubeproxy-ipsec
│   │   ├── 1-setup-env.sh
│   │   ├── 2-kind-cilium-native-routing-with-kubeproxy
│   │   │   ├── 1-setup-env.sh
│   │   │   └── cni.yaml
│   │   ├── cni.yaml
│   │   ├── ipsec-ens160.cap
│   │   └── non-ipsec-ens160.cap
│   ├── a-cilium-native-routing-with-kubeproxy-wireguard
│   │   ├── 1-setup-env.sh
│   │   ├── 3-datapath
│   │   │   └── cilium-wireguard-ens160.cap
│   │   └── cni.yaml
│   ├── b-cilium-vxlan-with-kubeproxy-wireguard
│   │   ├── 1-setup-env.sh
│   │   ├── 3-datapath
│   │   │   └── cilium-vxlan-wireguard-ens160.cap
│   │   └── cni.yaml
│   ├── c-cilium-bgp-control-plane
│   │   ├── 0-ReadME
│   │   ├── 1-Cilium-BGP-Control-Plane.png
│   │   ├── 2-create-bridge.sh
│   │   ├── 3-setup-kubernetes.sh
│   │   ├── 4-setup-clab.sh
│   │   ├── 5-install-cilium-cni.sh
│   │   ├── 6-enable-cilium-bgp.sh
│   │   ├── 7-gc-resource.sh
│   │   ├── clab-bgp
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yml.bak
│   │   ├── cni.yaml
│   │   ├── startup-conf
│   │   │   ├── leaf0.cfg
│   │   │   ├── leaf1.cfg
│   │   │   ├── spine0.cfg
│   │   │   └── spine1.cfg
│   │   └── values.yaml
│   ├── cilium_1.13.0-rc5
│   │   ├── cilium-1.13.0-rc5.tgz
│   │   ├── cilium-bandwdith-manager
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-100M.yaml
│   │   │   ├── 2-10M.yaml
│   │   │   └── 3-test-bandwidth.sh
│   │   ├── cilium-bbr
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-netperf.yaml
│   │   │   └── 3-test-bandwidth.sh
│   │   ├── cilium-bgp-control-plane-lb-ipam
│   │   │   ├── 0-ReadME
│   │   │   ├── 1-Cilium-BGP-Control-Plane.png
│   │   │   ├── 2-create-bridge.sh
│   │   │   ├── 3-setup-kubernetes.sh
│   │   │   ├── 4-setup-clab.sh
│   │   │   ├── 5-install-cilium-cni.sh
│   │   │   ├── 6-enable-cilium-bgp.sh
│   │   │   ├── 7-enable-cilium-bgp-with-lb-ipam.sh
│   │   │   ├── 8-lb-ipam.yaml
│   │   │   ├── 9-test-lb-ipam.yaml
│   │   │   ├── a-gc-resource.sh
│   │   │   ├── clab-bgp
│   │   │   │   ├── ansible-inventory.yml
│   │   │   │   ├── authorized_keys
│   │   │   │   └── topology-data.json
│   │   │   ├── clab.yaml
│   │   │   ├── .clab.yml.bak
│   │   │   ├── cni.yaml
│   │   │   ├── startup-conf
│   │   │   │   ├── leaf0-boot.cfg
│   │   │   │   ├── leaf0.cfg
│   │   │   │   ├── leaf1-boot.cfg
│   │   │   │   ├── leaf1.cfg
│   │   │   │   ├── spine0-boot.cfg
│   │   │   │   ├── spine0.cfg
│   │   │   │   ├── spine1-boot.cfg
│   │   │   │   └── spine1.cfg
│   │   │   └── values.yaml
│   │   ├── cilium-clustermesh
│   │   │   ├── 1-setup-cilium-servicemesh-cluster1.sh
│   │   │   ├── 2-setup-cilium-servicemesh-cluster2.sh
│   │   │   ├── 3-enable-cilium-servicemesh.sh
│   │   │   ├── 4-clustermesh-verify.sh
│   │   │   ├── 5-clustermesh-service-affinity
│   │   │   │   ├── 1-service-affinity.sh
│   │   │   │   ├── 2-verify-service-affinity.sh
│   │   │   │   ├── echoserver-service.yaml
│   │   │   │   ├── netshoot-ds.yaml
│   │   │   │   └── verify-log-rec-2-verify-service-affinity.txt
│   │   │   ├── cluster1-install-log-rec.txt
│   │   │   ├── cluster1.yaml
│   │   │   ├── cluster2-install-log-rec.txt
│   │   │   ├── cluster2.yaml
│   │   │   └── clustermesh-connect-log-rec.txt
│   │   ├── cilium-dsr
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-datapath
│   │   │   │   ├── dsr_71_ens160.cap
│   │   │   │   └── dsr.datapath
│   │   │   └── cni.yaml
│   │   ├── cilium-dual-stack
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-cilium-ipv6-docs.html
│   │   │   └── cni.yaml
│   │   ├── cilium-ebpf-hostRouting
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── cilium-status
│   │   │   └── cni.yaml
│   │   ├── cilium-gateway-api
│   │   │   ├── 1-http
│   │   │   │   ├── 1-setup-env.sh
│   │   │   │   ├── 2-install-must-crd.yaml
│   │   │   │   ├── 3-install-cilium-cni.sh
│   │   │   │   ├── 4-metallb
│   │   │   │   │   ├── 1-metallb.yaml
│   │   │   │   │   └── 2-metallb-l2-config.yaml
│   │   │   │   ├── 5-deploy-demo-bookinfo.yaml
│   │   │   │   ├── 6-http-gateway-rules.yaml
│   │   │   │   ├── 7-test.sh
│   │   │   │   └── cilium-gateway-api-http.log
│   │   │   └── 2-https
│   │   │       ├── 1-setup-env.sh
│   │   │       ├── 2-install-must-crd.yaml
│   │   │       ├── 3-install-minica.sh
│   │   │       ├── 4-install-cilium-cni.sh
│   │   │       ├── 5-metallb
│   │   │       │   ├── 1-metallb.yaml
│   │   │       │   └── 2-metallb-l2-config.yaml
│   │   │       ├── 6-deploy-demo-bookinfo.yaml
│   │   │       ├── 7-https-gateway-rules.yaml
│   │   │       ├── 8-test.sh
│   │   │       ├── cilium-gateway-api-https.log
│   │   │       └── minica.pem
│   │   ├── cilium-host-firewall
│   │   │   └── 1-setup-env.sh
│   │   ├── cilium-ingress
│   │   │   ├── 1-http
│   │   │   │   ├── 1-setup-env.sh
│   │   │   │   ├── 2-metallb
│   │   │   │   │   ├── 1-metallb.yaml
│   │   │   │   │   └── 2-metallb-l2-config.yaml
│   │   │   │   ├── 3-ingress.yaml
│   │   │   │   ├── 4-deploy-demo-bookinfo.yaml
│   │   │   │   ├── 5-test.sh
│   │   │   │   └── cilium-ingress-http.log
│   │   │   └── 2-https
│   │   │       ├── 1-setup-env.sh
│   │   │       ├── 2-install-minica.sh
│   │   │       ├── 3-metallb
│   │   │       │   ├── 1-metallb.yaml
│   │   │       │   └── 2-metallb-l2-config.yaml
│   │   │       ├── 4-deploy-demo-bookinfo.yaml
│   │   │       ├── 5-ingress.yaml
│   │   │       ├── 6-test.sh
│   │   │       ├── cilium-ingress-https.log
│   │   │       └── minica.pem
│   │   ├── cilium-ipsec
│   │   │   ├── 1-native-routing
│   │   │   │   ├── 1-setup-env.sh
│   │   │   │   ├── cni.yaml
│   │   │   │   └── ipsec-datapath
│   │   │   └── 2-vxlan
│   │   │       ├── 1-setup-env.sh
│   │   │       └── cni.yaml
│   │   ├── cilium-ipv6-big-tcp
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-net-perf.yaml
│   │   │   ├── 3-test.sh
│   │   │   └── ipv6-cilium-without-big-tcp
│   │   │       ├── 1-setup-env.sh
│   │   │       ├── 2-net-pert.yaml
│   │   │       └── 3-test.sh
│   │   ├── cilium-kubeproxy-mode
│   │   │   ├── direct-routing
│   │   │   │   └── 1-setup-env.sh
│   │   │   └── vxlan
│   │   │       └── 1-setup-env.sh
│   │   ├── cilium-kubeproxy-replacement-ebpf-mode
│   │   │   ├── direct-routing
│   │   │   │   ├── 1-setup-env.sh
│   │   │   │   ├── cilium-status
│   │   │   │   └── cni.yaml
│   │   │   └── vxlan
│   │   │       ├── 1-setup-env.sh
│   │   │       └── cilium-status
│   │   ├── cilium-kubeproxy-replacement-mode
│   │   │   ├── direct-routing
│   │   │   │   ├── 1-setup-env.sh
│   │   │   │   └── cilium-status
│   │   │   └── vxlan
│   │   │       ├── 1-setup-env.sh
│   │   │       └── cilium-status
│   │   ├── cilium-l2-aware-lb
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── l2-aware-announcement.log
│   │   │   └── values.yaml
│   │   ├── cilium-lb-ipam
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-lb-ipam.yaml
│   │   │   ├── 3-test-lb-ipam.yaml
│   │   │   ├── 5-datapath
│   │   │   │   ├── .cilium-lb-ipam.datapath.swp
│   │   │   │   └── LoadBalancer IP Address Management (LB IPAM) — Cilium 1.13.0-rc5 documentation (2_12_2023 8_01_00 PM).html
│   │   │   └── cni.yaml
│   │   ├── cilium-metallb-bgp-control-plane-lb-ipam
│   │   │   ├── 1-Cilium-BGP-Control-Plane.png
│   │   │   ├── 2-create-bridge.sh
│   │   │   ├── 3-setup-kubernetes.sh
│   │   │   ├── 4-setup-clab.sh
│   │   │   ├── 5-install-cilium-cni.sh
│   │   │   ├── 6-metallb
│   │   │   │   ├── 1-metallb.yaml
│   │   │   │   └── 2-metallb-l2-config.yaml
│   │   │   ├── 7-enable-cilium-bgp-with-lb-ipam.sh
│   │   │   ├── 8-gc-resource.sh
│   │   │   ├── clab-bgp
│   │   │   │   ├── ansible-inventory.yml
│   │   │   │   ├── authorized_keys
│   │   │   │   └── topology-data.json
│   │   │   ├── clab.yaml
│   │   │   ├── cni.yaml
│   │   │   └── startup-conf
│   │   │       ├── leaf0-boot.cfg
│   │   │       ├── leaf0.cfg
│   │   │       ├── leaf1-boot.cfg
│   │   │       ├── leaf1.cfg
│   │   │       ├── spine0-boot.cfg
│   │   │       ├── spine0.cfg
│   │   │       ├── spine1-boot.cfg
│   │   │       └── spine1.cfg
│   │   ├── cilium-pwru
│   │   │   ├── 1-setup-env.sh
│   │   │   └── cni.yaml
│   │   ├── cilium-sctp
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-sctp-demo.yaml
│   │   │   └── 3-test.sh
│   │   ├── cilium-socket-lb
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-setup-env.sh
│   │   │   ├── 3-datapath
│   │   │   │   ├── 1-socket-lb.datapath
│   │   │   │   └── Cilium 1.6_ KVstore-free operation, 100_ kube-proxy replacement, Socket-based load-balancing, Generic CNI Chaining, Native AWS ENI support, ... (2_13_2023 11_21_38 AM).html
│   │   │   ├── cni.yaml
│   │   │   └── flannel.yaml
│   │   └── cilium-wireguard
│   │       ├── 1-setup-env.sh
│   │       ├── cilium-wireguard.datapath
│   │       └── cni.yaml
│   ├── d-cilium-bandwidth-manager
│   │   ├── 1-setup-env.sh
│   │   ├── 2-test-bandwidth.sh
│   │   ├── cni-100M.yaml
│   │   └── cni.yaml
│   ├── e-cilium-ingress-support
│   │   ├── 1-cilium-ingress-http
│   │   │   └── http.txt
│   │   ├── 2-cilium-ingress-https
│   │   │   └── https.txt
│   │   └── ingress.txt
│   ├── f-cilium-dual-stack
│   │   ├── 1-setup-evn.sh
│   │   ├── cilium-ipv6-docs.html
│   │   └── cni.yaml
│   └── g-cilium-NAT46-NAT64
│       └── 1-setup-env.sh
├── cniipam
│   └── file
├── env.sh
├── flannel
│   ├── 1-flannel-udp
│   │   ├── 1-setup-env.sh
│   │   ├── 2-gc-resources.sh
│   │   ├── 3-datapath
│   │   │   ├── flannel-udp.datapath
│   │   │   ├── flannel-udp-ens160.cap
│   │   │   ├── flannel-udp-pod-eth0.cap
│   │   │   └── flannel-udp-veth.cap
│   │   ├── 4-reference
│   │   │   ├── flannel-udp-mode.topo
│   │   │   ├── TUN_TAP interface (on Linux) - _dev_posts_ (11_6_2022 4_32_46 PM).html
│   │   │   ├── 【云原生虚拟化】一文读懂网络虚拟化之 tun_tap 网络设备 - mdnice 墨滴 (1_29_2023 11_07_55 AM).html
│   │   │   └── 云原生虚拟网络 tun_tap & veth-pair - luozhiyun`s Blog (1_29_2023 11_07_58 AM).html
│   │   ├── bridge
│   │   ├── cni.yaml
│   │   └── flannel.yaml
│   ├── 2-flannel-host-gw
│   │   ├── 1-setup-env.sh
│   │   ├── 2-gc.sh
│   │   ├── 3-datapath
│   │   │   └── flannel-host-gw.datapath
│   │   ├── 4-reference
│   │   │   └── refer
│   │   ├── cc.yaml
│   │   ├── cni.yaml
│   │   └── flannel.yaml
│   ├── 3-flannel-vxlan
│   │   ├── 1-setup-env.sh
│   │   ├── 2-gc-resorces.sh
│   │   ├── 3-datapath
│   │   │   ├── 1-point-to-point
│   │   │   │   └── p-2-p.datapath
│   │   │   ├── 2-muticast-mode
│   │   │   │   └── muticast-mode.datapath
│   │   │   └── flannel-vxlan.datapath
│   │   ├── 4-reference
│   │   │   └── refer
│   │   ├── cni.yaml
│   │   └── flannel.yaml
│   ├── 4-flannel-vxlan-directrouting
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 3-install-flannel-vxlan-directrouting.sh
│   │   ├── 4-datapath
│   │   │   ├── 1-point-to-point
│   │   │   │   └── p-2-p.datapath
│   │   │   ├── 2-muticast-mode
│   │   │   │   └── muticast-mode.datapath
│   │   │   └── flannel-vxlan.datapath
│   │   ├── 5-reference
│   │   │   └── refer
│   │   ├── 6-gc-resource.sh
│   │   ├── clab-flannel-vxlan-directrouting
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yml.bak
│   │   ├── cni.yaml
│   │   ├── flannel.yaml
│   │   └── startup-confg
│   │       └── gw0.cfg
│   ├── 5-flannel-ipip
│   │   ├── 1-setup-env.sh
│   │   ├── 2-gc-resource.sh
│   │   ├── 3-datapath
│   │   │   ├── flannel-ipip.datapath
│   │   │   └── ipip0-ens160.cap
│   │   ├── 4-reference
│   │   │   └── refer
│   │   ├── cni.yaml
│   │   └── flannel.yaml
│   ├── 6-flannel-ipip-directrouting
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 3-install-flannel-ipip-directrouting.sh
│   │   ├── 4-reference
│   │   │   └── refer
│   │   ├── 5-gc-resource.sh
│   │   ├── clab-flannel-ipip-directrouting
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yml.bak
│   │   ├── cni.yaml
│   │   ├── flannel.yaml
│   │   └── startup-confg
│   │       └── gw0.cfg
│   ├── 7-flannel-ipsec
│   │   ├── 1-setup-env.sh
│   │   ├── 2-gc-resource.sh
│   │   ├── 3-datapath
│   │   │   ├── flannel-ipsec.datapath
│   │   │   ├── flannel_ipsec_ens160_interface.cap
│   │   │   ├── pcap_flannel_ipsec.datapath
│   │   │   └── pcap_flannel_ipsec_ens160.png
│   │   ├── 4-reference
│   │   │   ├── 1-使用 ip xfrm 手工配置 IPsec VPN (11_9_2022 7_49_04 PM).html
│   │   │   └── ipsec_tunnel_mode.png
│   │   ├── cni.yaml
│   │   ├── flannel.yaml
│   │   └── ipsec-manual.topo
│   └── 8-flannel-wireguard
│       ├── 1-setup-env.sh
│       ├── 2-gc-resource.sh
│       ├── 3-datapath
│       │   └── flannel-wireguard.datapath
│       ├── 4-reference
│       │   ├── 2-wireshark-wg.png
│       │   └── man_wg.txt
│       ├── cni.yaml
│       └── flannel.yaml
├── .git
│   ├── branches
│   ├── COMMIT_EDITMSG
│   ├── config
│   ├── description
│   ├── FETCH_HEAD
│   ├── HEAD
│   ├── hooks
│   │   ├── applypatch-msg.sample
│   │   ├── commit-msg.sample
│   │   ├── fsmonitor-watchman.sample
│   │   ├── post-update.sample
│   │   ├── pre-applypatch.sample
│   │   ├── pre-commit.sample
│   │   ├── pre-merge-commit.sample
│   │   ├── prepare-commit-msg.sample
│   │   ├── pre-push.sample
│   │   ├── pre-rebase.sample
│   │   ├── pre-receive.sample
│   │   ├── push-to-checkout.sample
│   │   └── update.sample
│   ├── index
│   ├── info
│   │   └── exclude
│   ├── logs
│   │   ├── HEAD
│   │   └── refs
│   │       ├── heads
│   │       │   └── master
│   │       └── remotes
│   │           └── origin
│   │               ├── HEAD
│   │               └── master
│   ├── objects
│   │   ├── 00
│   │   │   ├── 2b0a3574c6cc5745118c512ec6e997eb8bc1c2
│   │   │   └── 492019367eb8dd3b2e8cefe8f3c0d57d046ba2
│   │   ├── 01
│   │   │   └── 10e1c2d4643f1ce1cd3cbccbc4895e0f88301b
│   │   ├── 02
│   │   │   ├── 811d5fbc84cfb1a370a222646977ba93e74a04
│   │   │   └── abcc420cc2877ce2d5f37d81fd600dcf980aed
│   │   ├── 03
│   │   │   ├── 37164254da9a3a704f37d48780839f27c4f65f
│   │   │   ├── 52602e3bc684ec43c3364eda28200326c79a6a
│   │   │   ├── 6974113c60115728e694fe58dff358f89c88c1
│   │   │   └── a0426ea4d56fb2e6e01c7a50bdbcc63cfb7c02
│   │   ├── 04
│   │   │   ├── 164d21968c017ff107e77b6e2a3cb91dfaace5
│   │   │   ├── 18888cbc7166288d3b66972dd14b45157e3623
│   │   │   └── 4bb7ec6e89fde5038420316cdec8d19c304c85
│   │   ├── 05
│   │   │   ├── 17273565b499e1ddca8150416a3ca71d5f0e75
│   │   │   ├── 89bed083ada69e84cf72d50fa35dc8977d669b
│   │   │   ├── de8be1cae7c29ea334916d7be8de7651379cdb
│   │   │   └── fefe3b1eff7bad809717ec6443d56851b5a21b
│   │   ├── 06
│   │   │   ├── aebffc67e9620177d030c64d60f8273d214dfe
│   │   │   ├── c2bff5d08bd11b31968dd9c2f8d3908d50b10e
│   │   │   ├── c741fb2dca9f8b6caa401d8af88129019d8674
│   │   │   └── d2e1b05745f81bf1fc5dc9908742d91c28cffb
│   │   ├── 07
│   │   │   ├── 13e8e4cf68285975204688f6be6897f1685e46
│   │   │   ├── 19a83d6867cd05932a420c2149db543d596ad7
│   │   │   ├── 3046f4edbde102bd36cc1492f4dc50281b99f5
│   │   │   ├── c79c3281ca7f8c18668e4bfbd89d053a13e143
│   │   │   └── e03de4fc679e099852364065bc9c6e5b99c5aa
│   │   ├── 08
│   │   │   ├── 36e462ae66bd4355ef78b81607b38b5f251418
│   │   │   ├── 44aad55d34a5487787eb86571a747693721945
│   │   │   ├── 4faf7d3421ee219973c64a39cad46b860d98ef
│   │   │   └── ce762b1fa4ec68ef7d015fec2f58b9ba767eda
│   │   ├── 09
│   │   │   ├── 5eba6a76fd1c805863dd840d05c1659e6086bf
│   │   │   ├── ac030562a0bb37a8bda8cf8512d0e8c6bb5f83
│   │   │   ├── d12d9b0e379eb3b255f0c780d430e504667544
│   │   │   └── e60df2ca6aced288c1e4efddd14023155dcd37
│   │   ├── 0a
│   │   │   ├── 13af5257840048ef99f1119b6bd0d1ae4e11b6
│   │   │   ├── 1c70e58b78531caa609f5d02aa4a4463820594
│   │   │   ├── 6a0143bb1cc6e9494c22fd24846b30fc4bce1a
│   │   │   └── b516197d6a03591b0540f7e3801809a05e82c1
│   │   ├── 0b
│   │   │   ├── 1ff79de341fdadfcd2e2c36728f6590082647d
│   │   │   ├── 8895afece673a700fc3eb41286c8d0cfde0fb5
│   │   │   ├── a768312d372e03d0abfed3f12abf1160f4a981
│   │   │   ├── b075b579ff12a84b82430324db17ea5c04fc59
│   │   │   └── cec8c3cdde98f8d51e45232052dcef7eb840d4
│   │   ├── 0c
│   │   │   ├── 1bc992057c10631b4f38d762e68a49ada9719b
│   │   │   ├── 571de24cb7d0856fd3ffc5cfe4cdaa9f3da0a3
│   │   │   └── 8b42d1dc7e19a1d1b23b5d7018b23a514e092e
│   │   ├── 0d
│   │   │   ├── 271683bc390e6c34fdbe442bbef87059063ae7
│   │   │   ├── 54f624370430642b39f6a38cb03d7ff4cdc05e
│   │   │   ├── 6f53a9e2ee378ee68b81dcfd89a331bc6bdde2
│   │   │   ├── bd4cc1489c0762b42889bfa0982a913113717d
│   │   │   └── c7e34938f8cba8e9924fa9e6d1888a89d16d9a
│   │   ├── 0e
│   │   │   ├── 67a2a89845a22c578553b8a2c78a40f9cd382c
│   │   │   └── c2172089bfcd6e998c5988941d1fcea13f80bd
│   │   ├── 0f
│   │   │   ├── 2beafc492648e0df79a1fe692fbeb6ad290587
│   │   │   └── ab131957fd13e05338a2eb1958d0cf70f47410
│   │   ├── 10
│   │   │   ├── 63248c8539ef651e7110fd18c214a66ff38ffa
│   │   │   ├── 8a7420a28e3534ccce8414ba0376fe78d1b18c
│   │   │   └── d2273f5f23aabddd24a7f684643471b84b124a
│   │   ├── 11
│   │   │   ├── 191ec8f046bec296ef8aea8480ad6313f181a8
│   │   │   ├── 5b32177a84e7e99ac8e8721eb93bede23551b7
│   │   │   ├── 6a1d51dcc7a0fcd3cc9c0a264c1fd9e63c79d5
│   │   │   ├── b8c0f2a25de23f0d16d96e9c3f28880f0e5bea
│   │   │   ├── d7a2815ffeca5579324a267141fc32d840cf51
│   │   │   └── eaeb57366e30d971cfa4a3bc7eefef41240d9d
│   │   ├── 12
│   │   │   ├── 15d62fcab6079b527d074fdfd8d0fe8c551bbe
│   │   │   ├── 17bca06d9e35cdfe86349194b6700f2e67a033
│   │   │   ├── 9bafdc1b58172b4a84fbdedd66494c2882ae9c
│   │   │   └── aedd08a02b8361f358b4d300dc881209e9ba03
│   │   ├── 13
│   │   │   ├── 12a519ebba7161518253d2fdbdd2b1753b7d36
│   │   │   ├── 27c160f3195ceec5baad0a546664f91d1f1b22
│   │   │   ├── 6922b60f5df3bcdbd46c226050b41baf0276a1
│   │   │   ├── b212065b1cf2e809dc5461365b3f5f15391cf3
│   │   │   └── df582a51a6d3c02154903f225ab05da811f938
│   │   ├── 14
│   │   │   ├── 0d0fc16164f5bf52a556e7939634aa0d34abb2
│   │   │   ├── a56c8262d1c0084e7381bca07073cae127f533
│   │   │   └── b6180056fe7fa1895b857bf3f0372fb6e00ccd
│   │   ├── 15
│   │   │   └── e8eca34da18432f02990c1ad70a2e64a0b0c91
│   │   ├── 16
│   │   │   ├── 33e64f706396ea71c72d3bf28ba3b194e93437
│   │   │   ├── 34408ed0f0e3ca8f6f9188b3f7b4fd7a92a3b6
│   │   │   ├── 375178fca6312662c1cefdc307c07b7c631252
│   │   │   └── fbb8e35f9ad18ccbd75dc0ca9aac64be9a80c7
│   │   ├── 17
│   │   │   ├── 20b82dcfabe01744835604223da24c04adb11a
│   │   │   ├── 4b774b4f3282539746880fd1b5500ded5c5917
│   │   │   ├── 6240e7d1895e6d2a7a6303a4454d72552024df
│   │   │   ├── 9efc29a234124aae62f970f28f0282a3c45bd8
│   │   │   ├── c630bbfd53035a075593bab0e3f3bf1103e356
│   │   │   ├── c73a942d2b6ffa298abbaa7c8b1e8602f86562
│   │   │   └── d5a57726f78f9d5e8d9b3c364764a17694f68f
│   │   ├── 18
│   │   │   ├── 28df3846ffdde68f52129664a4b9e85f6f8b5e
│   │   │   ├── 886df1f5b090b9aa9f5c9ebcbe8675b351ab54
│   │   │   └── b2449cf0f79f95d3f23635b51f172f40e6a41e
│   │   ├── 19
│   │   │   ├── 5798436e425ac99cdc6b1ae269a2c2196ca9d9
│   │   │   └── 7f6f04411cc21a43d5fb67675dfcf925dbada5
│   │   ├── 1a
│   │   │   ├── 9360d143df5d5a242e4f3697ef99d8eb84ef1c
│   │   │   └── a59abb2491d1b9f449424fce6dee0d4d0917eb
│   │   ├── 1b
│   │   │   ├── 5973721a7ec01921a8fdda96419b35b60c34b7
│   │   │   ├── 639bf0727bcd7b32390d6e9f00550d3f18dd85
│   │   │   └── a1a628441a22c6dcaf05356ac73a2df35a5be8
│   │   ├── 1c
│   │   │   ├── 40bf91715170b4997cf10fc5e6dc0e731bf94a
│   │   │   ├── 524aee45b242842ed8f98c2afcde2d317dca81
│   │   │   ├── 68fb68ff81c779bd98e1833e1cb81c77d8a521
│   │   │   ├── 880add0e582f1bb91462730c9dbbe19b030793
│   │   │   ├── 90ca77e01eef36dfbaccebea8a6868bc95a17d
│   │   │   └── ef7046ccce3d427754de3dd639c7d5a77428c1
│   │   ├── 1d
│   │   │   └── 1a7b3c86764a75d57d9cc16263586f58287d11
│   │   ├── 1e
│   │   │   ├── 1b8825e0ef1b46ecf39333dcdcf0fd9dabe129
│   │   │   ├── 33a015d7926f603dfcb69a0904b8d1be32b567
│   │   │   ├── 5aecf58c21ab1234c02eaf6cba2901c0176f06
│   │   │   └── 77acce18c6a0195a9aa3d174d562718b79afc9
│   │   ├── 1f
│   │   │   ├── 0c470ca59892fd29a2bb2980bf45e65121546d
│   │   │   ├── 27df527a641fc9c02c83619f4d064b0e78caa0
│   │   │   └── 8ddae0b5cdfb97679e746dd89205298a19ff23
│   │   ├── 20
│   │   │   ├── 12210b9f364d59e5483ec58f705d634df04dca
│   │   │   ├── 515ab0e20fc787fcb2f8d4c0444691c8029791
│   │   │   ├── 67e3225de3a5ccbed609180dce26a980623233
│   │   │   ├── 8e9069f4a163724821702cde73090a4428dcb2
│   │   │   └── 9921a33a1274817cd494ec7d1d1b442fb32cbc
│   │   ├── 21
│   │   │   ├── 573ede817bb2ba3c7ec6fd97fafeee711ee836
│   │   │   ├── ae7b7a63f9b34f4e3029daaaca982fea4e31b4
│   │   │   └── bad5b027faa6808b6b41a209fc629003bba647
│   │   ├── 22
│   │   │   ├── 955e180bead12b16c2b1ac74124fa78e5d1e80
│   │   │   └── e3b505711e9af5eacd2331a515adf92d7b8c3f
│   │   ├── 23
│   │   │   ├── 80eb40382d444b53daef7240c71062e1c6fbe1
│   │   │   └── c1fc70b5096cdbc05092e1a2e816bf456713c5
│   │   ├── 24
│   │   │   └── 2ca65948ce40de20fdc160f5f5dd961efb1209
│   │   ├── 25
│   │   │   ├── 66c9ff4bfbbacb27f4fe38f0b5a93dfc817696
│   │   │   ├── a0aa3824f240eec95f153272f555bbc128b27e
│   │   │   └── e889862027416e9faeb770a9e084c56eba927e
│   │   ├── 26
│   │   │   ├── 176da0917d8211d4077643355f537a09d5b624
│   │   │   ├── 473b7a4826096d5e51076ee981bd75615a8b01
│   │   │   ├── a14baf3b4b79470cc97964b3dce05244593ef3
│   │   │   ├── abe96eb9f871cbc3ff6ad4d078bbdb818398df
│   │   │   └── b2843e7028cb2074a77c7e012d632db9e30b34
│   │   ├── 27
│   │   │   ├── 812c2df2e6e2724275b138bb3cda93fb09d502
│   │   │   └── a27f8e3ee2734090cc03bed6e91e8b59bcf981
│   │   ├── 28
│   │   │   ├── 7acf84e3cfc4a7c186ee8c4ad5e4bc8774d541
│   │   │   └── a3dbb6497bfa4f73fb0de88f522ac1ba529e03
│   │   ├── 29
│   │   │   ├── 05d12fe71be309d98a01a00b0dcd6f5feaf9f3
│   │   │   ├── 291b671bc611ce0af81e8e984f2dea1f1f8e68
│   │   │   └── 56988b4b9f2602ffc5f1caae43107da21423ad
│   │   ├── 2a
│   │   │   ├── 0f397e7bcfd3d1b0ddf08fd00d13fa8c2426c4
│   │   │   └── 2d64ce4e90fbdba61b953b1871b9c7b0379e6c
│   │   ├── 2b
│   │   │   ├── 111844ae6eb49eaa625fd1b891a9e63c65083e
│   │   │   ├── 544d421061d6bec7adef02bc0dd252dde80f09
│   │   │   └── b2302bc7dfcabe2afb0936e5caadc3c5a30b42
│   │   ├── 2c
│   │   │   └── 184c25117d3311bf57d3278b19060bed34bbcc
│   │   ├── 2d
│   │   │   └── e67d5b67e58ed812ef54a74b9b7597c9feb15a
│   │   ├── 2e
│   │   │   ├── 8c8da2e2b92a9da282150e4e44985ba8477686
│   │   │   ├── 9b3bc1ae8a44e75236ee87904877896e1d3518
│   │   │   └── b60463d6f8e113705e33dbcc3dc79482587009
│   │   ├── 2f
│   │   │   ├── 1e295aaecf38d7d992f14fca49555172056d97
│   │   │   └── eada32e3c6f7260aea49648fa69e986e576044
│   │   ├── 30
│   │   │   ├── 2c03bd81698186a2f0be2119f9dbca27b62531
│   │   │   ├── 531f196a2143748c417c0a066d3f45d3c5ccaa
│   │   │   ├── d4ff7a1a97b6679252677a2d8c8320d6ccd108
│   │   │   └── f76e2b3a64f5972a732fc23ec95eb8578a585f
│   │   ├── 31
│   │   │   ├── 5948fcbddd4d7f8b80dd4c30fc3871c52bbd8b
│   │   │   ├── 66ca5a6475e96c004fc0e3753b626ee6b6989f
│   │   │   └── b82d6eb8b9f9977e34fa09bae41d3daa71dcdc
│   │   ├── 32
│   │   │   ├── 1f8943cfc07e3361c1a17acf0941c33498aaae
│   │   │   └── 47b33a21a4eaf5439db17a1e6e88bce98c30c1
│   │   ├── 33
│   │   │   ├── 2d51b601fc0f8dc116d6161ab55b73ad0ed6aa
│   │   │   ├── 30e9d15ea47699597feabee7fe0c4de7dfacaf
│   │   │   └── d2486145bb3c30340157af4d0c7a553eb12174
│   │   ├── 34
│   │   │   ├── 0ba83518acc0be3811993a99031179d51b44e1
│   │   │   ├── 5f82902ebcb6674f5310597f917f36be5a197a
│   │   │   └── 9ef11068e830a88a775743b0e4bf468f82ea7e
│   │   ├── 35
│   │   │   ├── 70be9400fe0083b660ad7cddb14455544643d3
│   │   │   ├── 88785f0c7faca1566579d9c03ae94bd9a1b5e6
│   │   │   └── d90610861d45d0aec188515d4ad976c69e130a
│   │   ├── 36
│   │   │   ├── 0b99c264414138f172c2cba089f30df877de27
│   │   │   ├── 631e68c9894c199c96163177db8d4e824d0b5a
│   │   │   ├── 662689c2debb0fc39782114688069f1f32c7f5
│   │   │   ├── 985913ba165e3cff9b46a098b4f5abff5724d0
│   │   │   └── a1763904b701e69b6b19fc79b077a76a64ef08
│   │   ├── 37
│   │   │   ├── 577818b9ccfdb8eb2dcf6eeb77aa97fb9c70d5
│   │   │   └── 6ef301d16087b48d4cd8602c8fb809ef7219da
│   │   ├── 38
│   │   │   ├── 755c166cacc920bafb05c570e3967fb5b4a7a3
│   │   │   ├── baaff9f669e64b2cc04d61c58e3afb76fe12d0
│   │   │   ├── cd334e8d99229dac2c8f35ba38098715047a5c
│   │   │   ├── edea69f50e2b35bbd29ec7e0556d75605a1770
│   │   │   └── f17a38529f19e4f11b5cf73dbb46aa388e0e19
│   │   ├── 39
│   │   │   ├── 30de279b8b518ed9c6d8c9f40eeab00dc6419b
│   │   │   ├── 4eab6a8ed531705644c5a98f4f44002adcdb44
│   │   │   └── c06c0c08635b8c8cbf40d8a38403b45cdeba22
│   │   ├── 3a
│   │   │   ├── 334815ad535ffcab20879b6987fa3c1ed5afad
│   │   │   └── bd142949bed665850bbb36d9b0f859c3c47adc
│   │   ├── 3b
│   │   │   ├── 062a4e507a41c45dddd20c3b23ef9bc247229b
│   │   │   ├── 0f551845195c8dab27d11a19e6640e2615868d
│   │   │   ├── 70a937b3ad621be1a97251fa97824c659da04a
│   │   │   └── b7b73d250fa43084e3e7d97f593ced8ab02537
│   │   ├── 3d
│   │   │   └── 221e994993c97d047e73e8ff714edf59805d55
│   │   ├── 3e
│   │   │   └── 1ebced2fe29e754770e1e64547d8239294406f
│   │   ├── 3f
│   │   │   ├── 0a1ea16d1bc8db84d17681aef1feddf294b0ef
│   │   │   ├── 951927bc9577f03bcc423327440bee122c5781
│   │   │   └── cf1035e48e68d27ffd195f471c9d8797004518
│   │   ├── 40
│   │   │   ├── 2dd419c28a7ae92f4f75c04e465f350ace6cbd
│   │   │   ├── 30c96affc6e230117784cd6f4a08529a7503a5
│   │   │   ├── cf1ee84823e368dbe8ecb37de69c48633c68e3
│   │   │   └── dd2f3242fda07fa993c48741dedb595f68b63a
│   │   ├── 41
│   │   │   ├── 4c3d7b31f3cccf9023c503d4a47ac4006c073e
│   │   │   ├── 503c677fcd2449b826c13e9afb539339afa1c8
│   │   │   └── e744631d825913005e8f1a490be1e09a7cecf2
│   │   ├── 42
│   │   │   ├── 19431aca9f1c3ac68ec94c6e311be575fa1ff3
│   │   │   ├── 1e2c4037c9b4206c19c9490220bc31cdc8ba61
│   │   │   ├── 1f57b806d013cd9a805a7f894cc6ea53d143bb
│   │   │   ├── 768a60789282b3222b48757b072bd00c170767
│   │   │   ├── 95da139dad4c4c240da66e66a0709d9a612e50
│   │   │   └── ee0437af0bfe2f4c1f7acaea8dce3a37f91c68
│   │   ├── 43
│   │   │   ├── 24a1b2e5cb0744d03b37a26a5abe7234b6fdfe
│   │   │   ├── 83e4262bbc6a994e8be1cefc1596650d77a12a
│   │   │   ├── ab61b393dab814d652ee9c16d620791c730194
│   │   │   └── dc4f34b660617e01f30d396e8271fa1092098a
│   │   ├── 44
│   │   │   ├── 1f8a06246d034d6aa95e2db7f9ca9168756111
│   │   │   ├── 2533839dc8d3e4638b4cc5be8f7d8d582b565e
│   │   │   ├── 5d63454089bde0f0da6f5d8819edd8d387d6cd
│   │   │   ├── 7391dbaa9a484da0d42d13412d85173658b770
│   │   │   └── c98133238eee77f83eb72d438f44cf69ec862b
│   │   ├── 45
│   │   │   ├── 040ccc3d95e061ab37e59f93d0f4777262d6c8
│   │   │   ├── 4c01c9350ba7088ac5df64845ccfab9c2a5e8e
│   │   │   ├── bac749077acc0ef925f12436f6a82b98424380
│   │   │   ├── c722e104cac5290e662e20beb5302ed50c4943
│   │   │   └── d35a1495a76b0e02f220461a7323031af259a5
│   │   ├── 46
│   │   │   ├── 832bda35671894b7ab65a2d9ae0d156c2bd8f4
│   │   │   ├── 8af970ba7e39506e608aaae833462058f71467
│   │   │   ├── cfcde40da6227ffef46224a2ead43a4fbe7f25
│   │   │   └── f1d496aa743c04c390f5728d9afa13e28da96a
│   │   ├── 47
│   │   │   ├── 36baaea5d98fbea864db01331ac578db969663
│   │   │   ├── be03b515c64323bc9abe78bff78595b495d457
│   │   │   └── fb91dd8fe8be07e493c926ed3b70dd2b7465e1
│   │   ├── 48
│   │   │   ├── 7c2988eadc6023aff16bcf0d83252eb66fa3f5
│   │   │   ├── c8be6b23b633fb0aaeb884a1769e3ee53724a7
│   │   │   └── f62da6c3374960a103856323a77ae6207fa14c
│   │   ├── 49
│   │   │   ├── 196240fb52133e3fa4334f8540d3542b438c2e
│   │   │   ├── 5587a6807443a8d52bc5e008a06d40c4cbe665
│   │   │   └── 6520b4c26c9383c2d04949d4e233af97927837
│   │   ├── 4a
│   │   │   ├── 08a81b7202e5d4529e2e904ccad058eaa31774
│   │   │   ├── 938de7a2a710896e479040ab78c60b790a1ef3
│   │   │   └── caa848184a6f00397d8c7564cfe98e6e06bc9a
│   │   ├── 4b
│   │   │   ├── 06ef45fd6ceceda1d85a18881afbd5e8cecf9a
│   │   │   ├── 3c39671a37eee775213580a8867f9d6dac20ac
│   │   │   ├── 4d803f018e37fc5c4427fa0f044a08ccb2c306
│   │   │   ├── 74f994cd838b4a5ba9be2bcffa7fd9d2689c59
│   │   │   └── c01b27557b99dd81984c748bcd8145e6218992
│   │   ├── 4c
│   │   │   └── 21c07402684ca84fd78cfd54abebfac7c247db
│   │   ├── 4d
│   │   │   ├── 40a972beaaa506305f18c5b3443efeea7fe451
│   │   │   ├── 7ca97744fa5688beef8fb6ffac19b11d49329a
│   │   │   └── d9cbc9b45c43cdd41e45511dcbb67396857dad
│   │   ├── 4e
│   │   │   ├── 1b9444c1c750d9bece5b55600c53c6e39e09b4
│   │   │   └── f19f8b8caf1370ef4888bd573d15081361e531
│   │   ├── 4f
│   │   │   ├── ac3950dffa303f931393cf0384b113c85d4fa2
│   │   │   └── fd9e2cca3b94a6dfdf9c1e57856755fc41e50a
│   │   ├── 50
│   │   │   ├── 05eb5547bed78c4ffe87db91e1dc7a7037f69e
│   │   │   ├── 10066f614d2dd6a20bcab337bfc5c0bae492fb
│   │   │   ├── 8bc03f4fb413605c384b34668806261ba74c51
│   │   │   ├── 8dc1c85188b3333c828477b04f9db7958739a4
│   │   │   ├── abdbacb64fac8f42930825b251e9225265b120
│   │   │   └── e3353945c5760da7f43b6db5def64cc9be43dc
│   │   ├── 51
│   │   │   ├── 77a0382b2d9d7060e63688014ce44d94cbc22e
│   │   │   └── bdeefb0d189571cbc711fda8eb47745eb6e592
│   │   ├── 52
│   │   │   ├── 2d9d27ebabe8de630354ad93fcf7d45d10f9e3
│   │   │   ├── 3d1f10d415bbae88f87a006729b6a9793b649b
│   │   │   ├── c8b297524dbc84085953f1ba796bf549f374b4
│   │   │   └── ffa5bd63bfe7ac52441568805b0ec4b158c6a1
│   │   ├── 53
│   │   │   ├── 459c8556c0c505191f03f84dd54c4f9bb6e76d
│   │   │   ├── e00b1d70da31bc44ba23f090578c08f11e47c5
│   │   │   └── ee322496724926cbd5d517b0ec06b502f83e3f
│   │   ├── 54
│   │   │   ├── 1b09e3de05d61d572fae02b19fd91b2a32e0c8
│   │   │   ├── 2369ec8cc557a2458acf53f08bacf6eea78643
│   │   │   └── ed2690ba4e268209119cfbbdc68bb353542a85
│   │   ├── 55
│   │   │   ├── 6813f4dca8081c89f3f5ffe3854c0ffdde26b6
│   │   │   ├── 6f803115633d64af55e1114f66e1006770402a
│   │   │   ├── 742d94478b869ed8a5a3d40c8236ef9721f822
│   │   │   ├── ef175c0f3d3e006edb9b062fcee6b86942a6a2
│   │   │   └── f199af25d865c23f2f683224213efccc5bd3ff
│   │   ├── 56
│   │   │   ├── 90236885d3b7b8e09969fcf14079ea01a3bf4b
│   │   │   └── bda08a47d3256594c3cf866d0f34dd0cf8c0fb
│   │   ├── 57
│   │   │   ├── 58f5ac10e3ac171eb934fbd6fecef4027c60c9
│   │   │   └── b0ddec4481ba460b6356d16c491a4f0544f6ac
│   │   ├── 58
│   │   │   └── 569b9cb4145ac5a2d2bbfa442032c19c5c1d26
│   │   ├── 59
│   │   │   ├── c28acf05a1de5278152cf1e70960e27bd5e3b4
│   │   │   └── c7b2c83f3c96253d0b238862f0ecfd92270f8a
│   │   ├── 5a
│   │   │   ├── 357be104b06e6076f5be84fb4cfa7029c28e03
│   │   │   ├── 9b01f7210e50ee1e4afc0325a2ea2dbc19266f
│   │   │   ├── d0ce45d9aa3eff57c4291025b496d0912143b9
│   │   │   ├── d890a631f1c8de692ebd6102a64cbf2cfa0e3d
│   │   │   └── f7c9aa0aace09f5ec35867baea0b1465a6aa0a
│   │   ├── 5b
│   │   │   ├── 88524b974f373d450312dcde3b7b7160d132a3
│   │   │   └── e8fa56cb1a52c1c6803050e0e88eae8efe36dc
│   │   ├── 5d
│   │   │   ├── 28a502c3093e923eeaaa7d3fb18ff1faa3e137
│   │   │   ├── 7190991fcfb393191c2049e26fa9ec71b23826
│   │   │   ├── a3f1120c71f2bc01a7f2d971c61673d9efc4d8
│   │   │   ├── dcff336ea11c93baf59a8c3b5adafd138b2693
│   │   │   └── e163aaecdcb972a31598882f10e38e7d05fb0c
│   │   ├── 5e
│   │   │   ├── 5f8b3c68fe1e2fc1cc3f56b8a66c6a45fef05f
│   │   │   ├── c02bcba93f5ee6bb16907ad8e2aa7604d3ffe2
│   │   │   └── e22801f07f328db1d1e1ab96fa5aa0047cd667
│   │   ├── 5f
│   │   │   ├── 2f4226e8147b2b3c0427939c6c793b4d3b7581
│   │   │   ├── 73016547a94fe1e21344dac2520679e4454dc3
│   │   │   ├── 9fd202e81c7f94a6ae6e923741d002cbf95d9a
│   │   │   └── af12a59008d47df9c95d1de06d0ee70e2890bf
│   │   ├── 60
│   │   │   ├── 3e84d066a2fe564dc75067463c83c7a5076614
│   │   │   ├── 471572eee8ef4db5532e019903735ee0b4ca7a
│   │   │   ├── b30ef50ab195b9c3ec8f2b4c9ac578f1b10f5f
│   │   │   ├── cd4393cd205cb7c953e8d2ac55f56a34792e20
│   │   │   ├── f49f8220eeac0093fef76e95b92bf9121b366f
│   │   │   └── f678f1e0705674c2a6946d5b1f2267e09831be
│   │   ├── 61
│   │   │   ├── 001b929e7a23be0e4bf6c7c41baa21eba4391c
│   │   │   ├── 4bc21d30225c1767501d392095649224348f40
│   │   │   └── 770c2200c819c5631d9651ad678044846e66ca
│   │   ├── 62
│   │   │   ├── 03d66b6b665d734ee6c2bd8dcecf21178f4d8e
│   │   │   ├── 0738c3d14b358f1aafe400494b88d4fd6f733b
│   │   │   ├── 34e81e1fb191ecadef000f3445eff69fccf24d
│   │   │   └── 90c9d51281c9b810b37d3debadcfee29e9123b
│   │   ├── 63
│   │   │   ├── 40fb3e4cd8a3d94d06b87ff3ac8ce5a138fff3
│   │   │   ├── 4c20b89aeebac65af207889ff2afe99fb617e4
│   │   │   ├── 6917c2c69a898f135353fb11b9e2e9639111fb
│   │   │   ├── 7beaf15529b77071404fc77d0e80935539634d
│   │   │   ├── cd1af24daea6dfc848457686c3799585150823
│   │   │   └── ea26be9c8139e78189988feddb4c79ab3c05f8
│   │   ├── 64
│   │   │   ├── 5eb5cc8c1d51b7ec43de610743c7e025b55c00
│   │   │   ├── 94bbc5d30958587aebf5697d07f6fe91879210
│   │   │   ├── 95fff035e27f35104b16c6a876bbe935ddfd2a
│   │   │   ├── b5b1bc542d125b3c710dba750b21e6d65a9bf1
│   │   │   └── dec66d1e661a7f8b1716092531a51a8bf5069a
│   │   ├── 65
│   │   │   └── b2a7c3ed795ca6e6ff1c9e3a6e4801efe13a05
│   │   ├── 66
│   │   │   ├── 2cc4ac4389d8b947db952e846340754a820ba1
│   │   │   ├── 5fcb5952b83c4c383958ccf40f65507875df33
│   │   │   └── b4c3d01673d12fdfdb7e7c79519ffe45801112
│   │   ├── 67
│   │   │   ├── 040bed9878fcd9352948adb2d7906f9f98933e
│   │   │   ├── 2fb26404c759c69a7e3d1a26d8902a59664402
│   │   │   └── 977fcb76f250cd731d5db53cb7bff8dac6e7e0
│   │   ├── 68
│   │   │   ├── 4d1f9b204159ef6b0d269a94f125109648fa28
│   │   │   ├── a35c9f9c3d1e1475b6d18bc3c3ee7ab2340d03
│   │   │   └── a3b4b260b246eee8f4a7e1ab396ce6e8375011
│   │   ├── 69
│   │   │   ├── 95e8d0c187b4ffe8f80a49d05f243908de542b
│   │   │   ├── eb014d85600071b0a3f4adadd7f8cbe94b1e34
│   │   │   ├── ed43dcda1bb670fc80d3d418e09e2c1b7585e2
│   │   │   └── eeeeee1ad7979a75010ef97017aedeb0f1da76
│   │   ├── 6a
│   │   │   ├── 1f5a960e1b7fe5768be513cf6cc794a895ef7a
│   │   │   ├── 3feaf1b6454d5ef8250bcd8eb9cfeb16931bfc
│   │   │   ├── d0a60f7598fcac9c396a64a3eff54835c773ed
│   │   │   └── f3b9ff884892e5b7a97f81074f0221a03a51c4
│   │   ├── 6b
│   │   │   ├── 1a053ff8cbd38d391e1c2594cec5102b8efbf4
│   │   │   ├── 44e2f5748f6fc3532efe7845d1ca4fa5b83c78
│   │   │   ├── 5f7e50ed4e18d3286257cda45a2bd81ad938b2
│   │   │   └── 6a4c7fb768a13c2b1e2b6113a67b3ee80d2364
│   │   ├── 6c
│   │   │   ├── 026baeff869d01fca4f46e71a327e18d110f50
│   │   │   ├── 56f36c98bffe9b8642a7af814d7c703a802745
│   │   │   └── 7ec2466c9d0b9ab3fb8021223d33f6cb43c7d2
│   │   ├── 6d
│   │   │   ├── 835520e1119d3ebd6823ff76c158fed3274fe7
│   │   │   ├── 8b3b2554db3236a1f2b085986bac739daeccf3
│   │   │   ├── 973fbf4b843a71006253b3a725a3813297f615
│   │   │   └── ba34a8c960954e2df80edbe3b64d181b371480
│   │   ├── 6e
│   │   │   ├── 57752e33e29c97ecbb42fbd00901727ff09d70
│   │   │   ├── 60e45d9633e582c1601ad43ba3b8dd787383f1
│   │   │   └── c45f4199e7bd8f87ac4b44780ebb1dc6070454
│   │   ├── 70
│   │   │   ├── 38849a74610980d4946b11c958550ebdf3e3e2
│   │   │   ├── 57de7a1b26e25e0e7be4299adc015d205f1ebf
│   │   │   ├── 68911b60bcf9dc1e91c82003e1e4084a3d407d
│   │   │   ├── 7027345202c97498e886637d8c2efbf5d4b332
│   │   │   └── a8bf8fa217646fc2fe6d2b83cfdf832a64fcb3
│   │   ├── 71
│   │   │   ├── 594b68c688ae9b53db14f8709121601cda51cb
│   │   │   ├── 618cffab8629434f1f1d3f56bcaf109f1211e0
│   │   │   ├── 72604f6d404bbacb127285f1b80770f3d2938b
│   │   │   └── f6ba096888cc194551794d9663b478535d8c58
│   │   ├── 72
│   │   │   ├── 622433fc4b1acf4687d853b1cf36b62d1db8f0
│   │   │   ├── 943766a1f3dedd05b7046555e6d70ecba84a19
│   │   │   └── aeb2952d76f86ec400760aea9e3c056f84bbdc
│   │   ├── 73
│   │   │   ├── 0a9e1253171d04c58ec2d069f8bdec976617ea
│   │   │   ├── 0ad7e0b5c63678ca641e15089578f818f27506
│   │   │   ├── 2fd993986c8964b5eb4988ae96762947b55e02
│   │   │   ├── 309e27a22760a49c904211f390be6f459db24f
│   │   │   ├── 359dde6b13484e6f3b13e1c3dbcf2b0e0defba
│   │   │   ├── ae033e87c880e54a8b3680297735b33a43f70b
│   │   │   └── bdd6bef98ed434f715c1a49def2f9c012c80b1
│   │   ├── 74
│   │   │   ├── 10054fcfd9774a3778052299503761b0dde5d0
│   │   │   ├── 77ae354a0d7c0d98a374502d58ed1fff764245
│   │   │   ├── a23d82f1da40f4028586e4a869b6313e9408b4
│   │   │   ├── b45ab765e46f9729e96e2247ae5d51f072a7eb
│   │   │   ├── b551f33d81360acbd22700f0e58ed3b2c598ed
│   │   │   └── c74e33906b33e314c41876c961c381ef3856f9
│   │   ├── 75
│   │   │   ├── a0350029083592b7c6f6c719be63a123af0543
│   │   │   └── f122fd258db6ec220ae22022fc8b3be04d21e7
│   │   ├── 76
│   │   │   ├── 59711784bfde565e5775b2be85fd3ed6238e28
│   │   │   └── 983f015be5fdd453e20e1c125ee14be72edcb8
│   │   ├── 77
│   │   │   ├── 27723beeda900c9f740f635264751f90b3d379
│   │   │   ├── 301d601f055bfe3a60dca394e1a4481a39b41b
│   │   │   └── 9eb49e7acf0890bee3b211a7bd03396a002f3c
│   │   ├── 78
│   │   │   ├── 48a3d9a07aa2d48e169cb1579ae79b0f50dc98
│   │   │   ├── 5d1c3a881535be7c57d679445618fa1294bcad
│   │   │   ├── ccccad4a5074604c6ede4b363e3a02014164bf
│   │   │   └── e0c6838ab8010b22c2343f870e72be837371a1
│   │   ├── 79
│   │   │   ├── 3b051896b3cd9fefe48b6babb7737d1f5a8118
│   │   │   ├── 4c1c4ba4ff737f7501beeabd26e738b831edb6
│   │   │   ├── 628c75a368b2566c3cbccc03fd1972db053c94
│   │   │   └── f8e9a983d7d2cfb30063654155bf7a62005a3f
│   │   ├── 7b
│   │   │   ├── 061612823541b8ecf06ff91be78c9ac56c4dfd
│   │   │   └── 8321163af77f532afc5a34716eb4c192647144
│   │   ├── 7c
│   │   │   ├── 08bb05d0de50456020b075c4d8ffc668009a7f
│   │   │   └── b1b5fbbc0200c3c218c03d8a2f8462df16aa4f
│   │   ├── 7d
│   │   │   ├── 070db08bc5f3ed9fec653f968ba2d72850e020
│   │   │   ├── 5f4b47f9f96eb4aca0ed1bd6f04d5b5921cef2
│   │   │   └── 9fad6bdbe3a487c7290553e6cb5da8207cb2b2
│   │   ├── 7e
│   │   │   ├── 112aed3bedda611b18aca9dfde98249595bb3c
│   │   │   ├── 3a834d42626f7c2e91c7879823821b3cc968e1
│   │   │   ├── 443eeec0bc5d866a1d1bc1f606bc68f263c422
│   │   │   ├── 6d44ae32bdc5ca0cc7fa1fc2c328794d3946da
│   │   │   ├── 85ad9f3362f9c60af162377128e8c8e044d133
│   │   │   └── b2e4c693aaf68cbfe7860f259b5141cd437ab8
│   │   ├── 7f
│   │   │   ├── 05e0427db0443eeee4a6d0bc9f6b40ddf1bf9e
│   │   │   ├── 55246f6b39a5c73e90878a347c8352ffdfbeb4
│   │   │   └── 713207530db53c4539953c361420518d508b72
│   │   ├── 80
│   │   │   ├── 13fef8cdf624d12ea60cb74bd3e991c606bed3
│   │   │   ├── 6766d08603b9d91164f2273cde1abaaa5f10a1
│   │   │   ├── 6bb6018fa3eed18420593f98f721b200092657
│   │   │   └── a6a4ceba184a711db8ad337d051daa5ebff318
│   │   ├── 81
│   │   │   ├── 05557835b7aced5e85e5ec632861bcc91d710a
│   │   │   ├── 0eae97f4a56627bdc004b376c90e9f644e3d49
│   │   │   ├── 67506d8f95558c426778631e8e8fead6b80992
│   │   │   ├── a74176293ce2d2179b26dc48880d7e8cceedb9
│   │   │   └── e4a504431709bf74d6542dd4739f487e1df33d
│   │   ├── 82
│   │   │   └── 1618521b51484c0086d3246e096ecd9a9bd5f3
│   │   ├── 83
│   │   │   ├── 1fa08bd2bb60831ea6f553111cab38039cb306
│   │   │   ├── 6fb3c2732e2889a78907860c11ed5328925dcb
│   │   │   ├── 9051d508ec4f135b3838006a45791edae9a96a
│   │   │   └── f4496a07442ed792f9c460419faa03f5f41b09
│   │   ├── 84
│   │   │   ├── 3a0a68338c8723fedcaaa0e02ad3d71551d40e
│   │   │   └── ef9fa22ef1d5655d9415065a88c090a8b4fee4
│   │   ├── 85
│   │   │   ├── 24db8c906fb19103eb6d870d00f6aefddd6a2c
│   │   │   ├── 671d1607d049beb3107a2217c6fef2d0a4e5cc
│   │   │   ├── 8536baedef697737a4fa5d52e2ab1ac7adf079
│   │   │   ├── c0fdcaf7c5e1d06365a365b1280da6905c26e2
│   │   │   └── f254c7a19251ad0338dc23f41563084701e494
│   │   ├── 86
│   │   │   ├── 1443f37c0cfc57fe3fce4c0eee0f4d63814455
│   │   │   ├── 2dc987b887eb0b81fca810297e13cde9b933d6
│   │   │   ├── 597deaa0fd16317d7b3a539d0f25ebc12689d9
│   │   │   └── aded1369702b1f56a8ad59c504aa64c9d0dfd3
│   │   ├── 87
│   │   │   ├── 63b24f3f5c3224468a677cc43e783eb8f7104c
│   │   │   ├── 81bb74ad74cfbb1882384d5100b4b8bf59c56c
│   │   │   ├── f0c26b053278bb3847ba4aa102263325008174
│   │   │   └── fb2ab46201901e44cd4165cf4bb3b7165497f9
│   │   ├── 88
│   │   │   ├── 81dc1eaadb75a7641e38020e404e46e1355677
│   │   │   ├── 8874d8bb0059a5cf3df8685123c4370a4ea39e
│   │   │   ├── c548b9ef1bfdbad3663f07f841494b43697908
│   │   │   └── e80136656f1fb7039b7171022f52ebe0a8a688
│   │   ├── 89
│   │   │   ├── 11f3b6865aabca142e5c48b3ff430bf15c1bb2
│   │   │   ├── 1fd5d09a8b9e9ce75dcc9faaa953338cbc02a8
│   │   │   ├── 45e471e26d65e87ff105b90ce6fb2cd87b7960
│   │   │   ├── 4abe0f3f4da63e27b2c56fe3de9e96091c0e59
│   │   │   └── 771c46f4f4db7c0472709c703c2baefb5a4d72
│   │   ├── 8b
│   │   │   ├── 2ded4123d475611a499eb509023083ddd9f77e
│   │   │   ├── 3b45692e87d53559a7844902c0d58f393f7cb8
│   │   │   └── a1441764eb2ce2bb31fd4bea1cfdfb7724bde7
│   │   ├── 8c
│   │   │   └── 87e9445d04223ff197957fde39b26972b92b3a
│   │   ├── 8d
│   │   │   ├── 2b47cbb705c2cb5ff27a9a2e929a27224a9e6d
│   │   │   └── c3b2effeff0493c1304d2892de3438fe57fd29
│   │   ├── 8e
│   │   │   ├── 72c43d7efc408b08236849c13d41024be9885e
│   │   │   ├── 8601c56cb94ea415d6d9db2c5631ea0e260022
│   │   │   └── c0a5ebf1dd5c35160a3a556502d605bf314d48
│   │   ├── 8f
│   │   │   ├── 1214dfdaa690b062646c5aed7227f4b9650713
│   │   │   ├── 16bacf812e1d5c4c570ff2af7e7c8342b6ceca
│   │   │   ├── 3e3da59183b929097dbe2214f3ea8d89329ecc
│   │   │   └── dbc80efa9a09b62b93696e25fbfadb9d4bf11a
│   │   ├── 90
│   │   │   ├── 1ccc9656b78c0c63fcaf0584dd4ba69961b79f
│   │   │   ├── 2a3c6435036c2a02ebc327dd9bc4c7e0f3f0b5
│   │   │   ├── 9cdb2358a0d603a5489ec605e3402c14d76c07
│   │   │   └── a67dcb418fc4df15072e44ddaeab22d34f64c6
│   │   ├── 91
│   │   │   ├── 0fa3bafcacbe19c03dd5d3251638a55a3657af
│   │   │   ├── 68e1c3eecc6f2898ea0f4c1108ab278ca687d7
│   │   │   ├── 7c17817d2ed74bd42a31f9c31ef3230586e94b
│   │   │   └── a47264ea435f4157958ad8288685bb1c8da2df
│   │   ├── 92
│   │   │   ├── 02047262982bea1a4fbc6d806a1250ee1e1a71
│   │   │   ├── 0dfa20e538eb4d2e20cb2254fae574862869c9
│   │   │   └── fd10ae118897591ac73fa400d0ed51fd1a6ddd
│   │   ├── 94
│   │   │   ├── 06878133105ba2adb81d41a0430e7f79004458
│   │   │   ├── 550935fbdc944f11a81e5c0783cb2ad5dd2679
│   │   │   ├── 71656f3cad3fef8f653e122416b7c7344b04ca
│   │   │   └── cd86d1aaa7ba1389bda917078c987fb08783ef
│   │   ├── 95
│   │   │   ├── 313c65a4fd0cec71488327c0b13067da9e687b
│   │   │   ├── 4460a59b08d5e670dd5f4af727cf93c4b878ce
│   │   │   ├── 57280d0e5d3b5642e70f437445e819aaa29ea0
│   │   │   ├── 7e046b31cb8b033da0920680920b9ae44d74ce
│   │   │   └── d3120e061bca1f76f37aafd6181bcf4c5f3cc6
│   │   ├── 96
│   │   │   ├── 343092f0a52c168282cc7a9523c6ce6f50a7e8
│   │   │   └── be21a9659127db553675d0e9c14852311af77d
│   │   ├── 97
│   │   │   ├── 1626755532d07d0331715138a058b96f2a5c4a
│   │   │   ├── 349699159e5650772f8667433aca9eaae5ad0e
│   │   │   ├── 7c5637b82aa9d91140600f9228309355bec736
│   │   │   ├── 9a3ed4eba311d1735fe409b430517fb02f5cd8
│   │   │   ├── c8eedf548234ed3f9ad0f2f4c749c31e69b645
│   │   │   └── d7a23458591d760a4e58f1abc04d095c48a75c
│   │   ├── 98
│   │   │   ├── 1e19cbaa260403cfc020de78d3f6bce11b0b21
│   │   │   ├── 77a694d6e4a8c6381e4962e147c37624d0a0b6
│   │   │   ├── c32fc0dcca6c23a9fd695dcd9eb2a044816f5f
│   │   │   └── ebe0b66938a12292c5a12eea7405d7b0281ad6
│   │   ├── 9a
│   │   │   ├── 59ed95b17f14db958a2e6040e3d7e44dfe2048
│   │   │   ├── 5a8af39a1d3fff907d3ec9e365d37ee637f331
│   │   │   ├── 602b982e88339000411ae1da222e3d69854d91
│   │   │   ├── 851a7cde930dbc6444b472a169a17639e17d3f
│   │   │   └── eba68aec84efbd83208b51873d3907863f59e8
│   │   ├── 9b
│   │   │   ├── 55cab55fdb0b27b204fa9b1955a62cb87f32f2
│   │   │   └── e4bae06375396748c98738afa620826ab40f85
│   │   ├── 9c
│   │   │   ├── 4b97e79e3f3c717bf1a7da27d1b06382daf6d3
│   │   │   └── 74cadea7f6f54f720e3df5d2cdfe2d9d0fff54
│   │   ├── 9d
│   │   │   ├── 66f366be17fb50f7af68b3166ea98b3dcab4ff
│   │   │   ├── 92eb8c62e00f4f01c5dcfcc55b4b59264192c0
│   │   │   ├── a355158368363fbdef73e7b09bda0285588a38
│   │   │   └── db737d1449b59b5b53bfcca544565ab1c22057
│   │   ├── 9e
│   │   │   ├── 48a5128a9d765501781188d48b7e1dbf737df1
│   │   │   └── d3b1974186287ed5896c3c922309ad14c3ba5d
│   │   ├── 9f
│   │   │   ├── 3385da0288cca88f1e20dfd4b9d5e8d0ef09eb
│   │   │   └── 977deba2d1e8860b0891117f43c142942fb99a
│   │   ├── a0
│   │   │   └── 9750b1e46593768ba864e17e9dd211849f7eea
│   │   ├── a1
│   │   │   ├── 3d6d7536fb834d116219fec3bc8b2065341e86
│   │   │   ├── 546758306db135bdbd067996397f68ab98e4b1
│   │   │   ├── bf072eb0a79862a82628d879bd7c1a8cb4ed04
│   │   │   └── d6aba72d262e34548f50a1370a0ce03a1eee65
│   │   ├── a2
│   │   │   ├── 1fae080ce5d78c9b7b50acd0fe35bfbbafb538
│   │   │   ├── 3397740a26718cc282fcff4cd6974099ce7754
│   │   │   ├── 3766ff37d34610cd076f5b763c663003d78afa
│   │   │   ├── 546b31b36de10a6aa2683f68a771489bdedb55
│   │   │   ├── 7b63876084a53c0fea80785648c1ff7adf82e5
│   │   │   ├── ef2bf411350979460bafe2603ee3ca4c7b79c0
│   │   │   └── efdddf6355041a73846593193ad924600f178f
│   │   ├── a3
│   │   │   ├── 41c70a0918f0c021ac756d0635130d2066a6fe
│   │   │   ├── c7445a580e0c793b00eba4ddb6a40500355188
│   │   │   └── fc73e3981721a32340dcb62047e9a08f9875d9
│   │   ├── a4
│   │   │   ├── 6b70bae961c418693fe80616df611a2796240f
│   │   │   ├── b479fec873debb95af5e14bd44fc2b48d8f7de
│   │   │   └── bf85b2d0697e54f30920f3d47dba45d9f9ce25
│   │   ├── a6
│   │   │   ├── 789fe7f02c22efddfe59ac71890878b73e2f9f
│   │   │   ├── 9c4f34bf30a785da9ea1032f7775b6a686c907
│   │   │   ├── dcaa9163a41e72d478a9e550eb4ba748358a0b
│   │   │   └── f2eb36005d908f3e6afde7071c1cd2aaf6a15d
│   │   ├── a7
│   │   │   ├── 10225ed65208a54a331f98391be887ac64ec2c
│   │   │   ├── 3e6a9029bd226a6324e12b7ba995777d56ff09
│   │   │   ├── 45d1db366def6156db1aad6406f15723593b93
│   │   │   ├── 6281f234689ab76be15ea0009c649a5fdc017f
│   │   │   └── f5ec9bae7ca089128ba308224ddbf33649d8e3
│   │   ├── a8
│   │   │   ├── 3930b64e049e2ac768b670605f61e3ee869c10
│   │   │   └── b6f3a0c492f26c3bdf0daedd413553c7e6afca
│   │   ├── aa
│   │   │   ├── 0aba0cb11d03be81f87e32baf756c43ebbf859
│   │   │   ├── 2cc888e18ab6d07e2e359967f5d260ea414ca0
│   │   │   ├── 53b83cbb3dd4a71e0684261392b5622074d6fe
│   │   │   └── ef74dbeed6f54ade499667fb9be53476d57f3c
│   │   ├── ab
│   │   │   ├── 4773f7b16ef11c75cfdfb5b0b922ee43af212a
│   │   │   ├── 52f00e8f1c081d67462d49a9ecdfc1fae9783e
│   │   │   ├── d0d1da66ca7a04284c0da5c46b503d6eacb254
│   │   │   └── f7782c1af9a88aea93db535f916c9f2f9b8e89
│   │   ├── ac
│   │   │   ├── 31846d742f55fed19796e20814f5cda0c09af4
│   │   │   ├── 55d5aceb7b280b017d4d5d3c05755173e512c5
│   │   │   ├── 5ebe1dd5c1252541f9a6299da02bde10bb03a3
│   │   │   ├── 85d96d93a5f93c74e006e8d7511c3d9ff921c6
│   │   │   └── a9787b0c3485460e2a492cfad4d62cdcb44a85
│   │   ├── ad
│   │   │   ├── 4db3acebfd5c5d93da281126a283c1dbb2a7bd
│   │   │   ├── 7f6fcd8c9800dd49ac0d5f2fda4fc02ab12fd0
│   │   │   ├── 8c910712b14f19bd457f2db914b48448f6336d
│   │   │   └── e3791b35d46d98671a1a476cb02ca5faa749ba
│   │   ├── ae
│   │   │   ├── 22c921d199b7874613ed678e01fbe75a5e3a58
│   │   │   ├── 5891e1d8332993977b8fb2d57ab733ac94330a
│   │   │   ├── 76b544e02ef7a315880918bbaa196ce90149f0
│   │   │   └── db72f86d1febed1d773a71cfb157a44f534fc6
│   │   ├── af
│   │   │   ├── 5f3af42e6785d51e6fc041ecd1ca1839b144be
│   │   │   └── 7660e395f4c6102aeb846a14c8ae35e6cdf4d3
│   │   ├── b0
│   │   │   ├── a47781d37afb5a42a3b3f6c7eca7a9a65afce6
│   │   │   ├── a4f650deb86790764fda481c26578156baff17
│   │   │   ├── cb14f1ca12e1cb0c6661ae55190681f23dec8e
│   │   │   ├── df5118585ce4dbf14badf0ec26b90b5bf98f99
│   │   │   └── e5cc279b7d2ef489076e93c42098e225d985f4
│   │   ├── b1
│   │   │   ├── 07b76a87e054cdfd4a6830214fec047ed8bcb9
│   │   │   └── 70a4e0bd2586ca53eb33c9349b942886c96227
│   │   ├── b2
│   │   │   ├── 9d7c882c8931e88b3e04ac5745e6cd27492e39
│   │   │   └── f2a061af18da621df3c03b604a9a017fc21093
│   │   ├── b3
│   │   │   ├── 096c086b0c4e66f0c7781040aa889fe014f4f4
│   │   │   └── 69e17cd8bd057d2ef3cc365d7176af58820da6
│   │   ├── b4
│   │   │   ├── 10fd2cc6be4551e98e793a7949881bb450bd9b
│   │   │   ├── 3d12e52f81fe91575d9760b34155203fe5a179
│   │   │   ├── 42658bc542861570dfc548e06b4b90b38d9b3a
│   │   │   ├── 8528c22572a32d34231554ba8fd43296663a57
│   │   │   └── 908069adfe12d95d142180f7c0145538fc0733
│   │   ├── b5
│   │   │   ├── 1835620e73a88ad9c51f77973dd2c236741c4b
│   │   │   ├── 592fe92136f62df76df1914b9faab3a7796eb0
│   │   │   ├── 7ece9a23c294e8da12abe6a2b4796578fd7200
│   │   │   ├── 8bb03c610aef1b25fd294d3c1585d6d35f2edf
│   │   │   ├── a0f1262ba2caf4bbab985c3dc4dac68da02fc5
│   │   │   └── f9aa5eec04beedb20286be6f1c6cf93215ec49
│   │   ├── b6
│   │   │   ├── 105d3a676b416583d4dda956a1b34901ab5e59
│   │   │   └── 2db279f72e836fa4ef04e1e51b630da9078333
│   │   ├── b7
│   │   │   ├── e3ae0589f3d05a273a9858165aad86a5ba2018
│   │   │   └── fe08349908895b1bb1e72ca06b82024bd4f929
│   │   ├── b8
│   │   │   ├── 6e51592c503d535b8f9f25fa582fc70b7f0875
│   │   │   └── b4bbf4ca998ab58e3acb3160d47c07658b5c55
│   │   ├── b9
│   │   │   ├── 7c65c620cfde323ad8f50e8ae435a5b1740131
│   │   │   ├── 9733769ec34df7be808503350201f460b01e05
│   │   │   └── e24c68ffc2af7f9ca88b4d9952922c588e64c2
│   │   ├── ba
│   │   │   ├── 7be4f1ecb269029a3d04a99ea285f9767d1eb2
│   │   │   ├── c2878307e65a46c5dcfdd598c2d2a938475eb8
│   │   │   ├── cfd4110902a0488ed3b158820aec090bb10f93
│   │   │   └── e110d95899b6ff9c3d0183fb65583621b12f9f
│   │   ├── bb
│   │   │   ├── 12e5e1d59f30ee70c9dbf7c259ea0301ce67af
│   │   │   ├── afe6ea0e36fbd3aa6e3b202e9f3490ded250a7
│   │   │   └── ed8402402ac9aecee6d0ca722ecdfb48c039be
│   │   ├── bc
│   │   │   ├── 47ca743435b9814a233a9f1b7b88c535077b12
│   │   │   ├── 61eca59313621d12f0daca98fd21d4b9586e9a
│   │   │   ├── 72f961dbd74c46d8a08949b3dd4d08a63271a2
│   │   │   └── 9ee9b4e16b2d9429e6e05b3519f7b2ea76836c
│   │   ├── bd
│   │   │   ├── 04f467fd4c3cd8aefb1c9fa81bb5a3ddf2ec2e
│   │   │   ├── 0ba7bafc9e5c1afb566211ceeba44a2b8ecdc9
│   │   │   ├── 48952f26a7e399df0ebf99e79b06039a86e036
│   │   │   ├── 6264ac231bc2a7fe4a230f5d2d994d87806616
│   │   │   ├── 65952ba6f76a23a23c879047c87b8d1ff8ea81
│   │   │   ├── 79c1a1c4978d78ce54b78d1f03fa5d171d1af8
│   │   │   ├── b05d94d5dadb4f096e72856101835a883eae81
│   │   │   ├── e1147524583271d3d0396bf3d8ad74a18b6f44
│   │   │   └── ee3a4b8c822bb20711b93437569140e6fbee66
│   │   ├── be
│   │   │   ├── 18b1663779ca8f78138feadf099922eb5b292a
│   │   │   └── b1b4910f949353266c9e98489d869c0f3f35a2
│   │   ├── bf
│   │   │   ├── d8f71216830e0766fefdd323dd3e8ba3bae17b
│   │   │   └── fd13fdcf84ffe795fdd3384ac0fb184cd3b9d7
│   │   ├── c0
│   │   │   ├── 2a0a8591b77a822395c65036c08de1e47eff96
│   │   │   ├── 592dbdd04d58f45bb65bfc1cd384ba4b5156a0
│   │   │   └── be57888dabf815c82132593d111b6e9caaf38d
│   │   ├── c1
│   │   │   ├── 6027e232d96c3a6b9e10a948e69ae01e652607
│   │   │   └── 784f1b87a3a06bea6c8846d84def78b0ae4260
│   │   ├── c2
│   │   │   └── aec2d5103b540d3cea0873758822ad42acf20b
│   │   ├── c3
│   │   │   ├── 11f1a3cbbe773ec4f0adda83cd2eee10835446
│   │   │   ├── 58aed5e937f6fcb23fe7c5ed64913d27b2781d
│   │   │   ├── ad76f456087963588b2c8d4de1eed0a9a030c4
│   │   │   └── b61aad9dc1ae7369f281c1acc711014aea771a
│   │   ├── c4
│   │   │   ├── 29492293ff4529ea1880e72e2d9650b55c0396
│   │   │   ├── 296eaa9c4e220d7e9c90ceebbc497cdc56e9ee
│   │   │   ├── 6f07abd087e36e86feda023fc14240683c2762
│   │   │   └── ae96805fc21ff97800bd2a2aa53bfb095467f3
│   │   ├── c5
│   │   │   ├── 8aa5007594ac987f1a43a1e35e5b2abb8de324
│   │   │   ├── b5bf661a7fafb93d4da895db739e98b707bbd8
│   │   │   ├── dea706ace7d250899cd79918732e599c0600ae
│   │   │   └── fc7fab1ed92dca92533b43482547166168c70a
│   │   ├── c6
│   │   │   └── e18243d354e26e3352144fbbb68872e58b10b3
│   │   ├── c7
│   │   │   ├── 5feff0c588dc13b70017a09745909a6de8f859
│   │   │   └── fc0b39e45f983e7199d4ebf478483098cd2cf9
│   │   ├── c8
│   │   │   ├── 640a718211eb5ecdc5ac65730761c832b738c3
│   │   │   ├── 6e91af3022a72a5c6bcd4045cfd2b4423d7dd3
│   │   │   └── e00f92eda4bc36554bd64344d9535173c59f39
│   │   ├── c9
│   │   │   ├── 0a15246674708f5710205e66c46591d3d5838d
│   │   │   ├── 14ccdad2a2770545f39862381d6cdd26557a77
│   │   │   ├── 4c29545ea01f57361f9b44e7583b08360b16fb
│   │   │   └── cb5b5783e4046995d2ba058f50daffb9dbca27
│   │   ├── ca
│   │   │   ├── 57bf1fe80e1e02b041a02806795b960771be1a
│   │   │   ├── 7b6d2218cc5b81b6af08dffd229ac35d3a71c5
│   │   │   ├── 8e1c57ba4491b8a83ba0e832601db28682cfc5
│   │   │   └── ed5aae3ec3e133d9d85929e875109ac3b53c03
│   │   ├── cb
│   │   │   ├── 0dfa03fd837f11eaefa1a73c41a5994d5a0cfe
│   │   │   ├── a03950aab379d210f1ad57618626f0b6187e8f
│   │   │   └── c20b5a844fe3262f9fa5bc0cbc970a3735ef8c
│   │   ├── cc
│   │   │   ├── 6999059392631e16af8143003aec23add106a7
│   │   │   ├── 9c146730e28015aba3624bbe92384f90d4f353
│   │   │   └── b9cd3b7bb573901025eff9755e88c1ab01b9df
│   │   ├── cd
│   │   │   ├── 3f03af345b0b035d4450280147bc1c76892a94
│   │   │   ├── 630a470ad7080db4cc6e1afce8043e57c8a068
│   │   │   └── ea8e67f31f5c3353bce4eebddfa00a43e6bee4
│   │   ├── ce
│   │   │   ├── 0d31d718d37cb9a868333fd1a1d7fc48cf9134
│   │   │   ├── 6b130ff2bf5b041b03ab2f6e92368d135c973a
│   │   │   └── ffedccb9449106b8448d4da835fe8cc1634c50
│   │   ├── cf
│   │   │   ├── 4b04599604d63fb0d959db938358ac8ba50c06
│   │   │   ├── 4cc2ffeb22a0ab1b38cb187848d745605a9097
│   │   │   ├── 5cd9eb8fd9c7da4779eb3d668324f4ccb829d6
│   │   │   ├── 611ae18833f25b60daeabbffc8e8d2167c7942
│   │   │   ├── 71f572cbf8541f395fb9407cf7473fdce90585
│   │   │   ├── 838ff83168ba01859b1782e96c4cfb144acd61
│   │   │   ├── 9638d9f822098b2ad06d481fb7e50ecb222786
│   │   │   └── 9888306e59f8dcc1dc829258ce1d805e261402
│   │   ├── d0
│   │   │   ├── 001192c8bd700cc2ec0a9c0723460767232e10
│   │   │   ├── 382e4231e847ae9b9f6ae375cfd0b10092e2b1
│   │   │   ├── 67ed822aaf84e47bd9237274e50ae31e48c744
│   │   │   └── 9cb0a740f6fc054e6ca7ddc91581fe99d0c6eb
│   │   ├── d1
│   │   │   └── 70411c0794e0303f2d2028fed2144a36ff63ec
│   │   ├── d2
│   │   │   ├── 41e098f0a41f4be70e9b332b364c0e46f55502
│   │   │   ├── 641f75c9ef4605c6182c45e1aaa487d97ce1d0
│   │   │   ├── 83760fc413b27afc8a1e7b8819afc6d1d3a277
│   │   │   └── f8dcf9e9f4d2c79d46d6b6bf5578f9ab3d0bc8
│   │   ├── d3
│   │   │   └── 0d764c366532bffe84fd536ee1c12000322b9a
│   │   ├── d4
│   │   │   └── 2cdddb5da0bc5fc8300f2b0b81df0f56d5524d
│   │   ├── d5
│   │   │   ├── 076f6f8190d5bed9bd9af0d47e6252b1770b7e
│   │   │   ├── 0cfb9ac81be3475daa052c3e0bf57fdf78ad6f
│   │   │   ├── 45af6fbf72cd8885df672408adb317d049daf6
│   │   │   ├── 81570d77731ff164262caa1774a0f04df2d0fa
│   │   │   ├── 841751cb71b795d14ff7b52142bd70e3cca4b5
│   │   │   ├── ac034c235534e0d96a2de91e8e308351dcebb8
│   │   │   └── fab72508e3d03f70cb43845f57b46670942f33
│   │   ├── d6
│   │   │   ├── 0998f10c1e00ad48286fd3d79a2ef8122cd0bc
│   │   │   ├── 1c9ccddaae1f4547134189e8bd23d528d9aa56
│   │   │   └── 755c6feeda26aedceb5678bb73802178ded3a0
│   │   ├── d7
│   │   │   ├── 3776e6b71cda2532a14c933fac6f0cebcedc91
│   │   │   └── b9020d761c77e68ef58452fda83fd873288468
│   │   ├── d8
│   │   │   ├── 9114cb6c1c3d1df70733d8e06f04e3bb383e12
│   │   │   └── f9fa00673cc9cac296c8fa2bbd135adda1d99a
│   │   ├── d9
│   │   │   ├── 3834ecce1d243a18000fa8d1d9424371b0db28
│   │   │   ├── 685b1326c705e98e6b520d51997f0fa93e69f7
│   │   │   ├── 9730da7b8b3ecccb8180f148168c25ae0a529a
│   │   │   └── b1afc30b04ee79e79e58ca5af32f5a25a8c93a
│   │   ├── da
│   │   │   ├── 02597a19d022e85f5d92018009b4d6beeb2b70
│   │   │   ├── 3f193f7b38b96303e6aec7b0af0bf900adfe71
│   │   │   ├── 5b9b067ccf60186cba24b9edeabd5eb7832c5b
│   │   │   └── fd862ea78a0c5fc47afc1c0548299686743920
│   │   ├── db
│   │   │   ├── 0825453e1a32c1bec6e4c56487abb5dfcdf99a
│   │   │   ├── 37c1253077a226700d70489b9bee4bbdbe6330
│   │   │   └── c3a5e9e8d0ffbbfcb3e86b359d2b88ba6f8a98
│   │   ├── dc
│   │   │   ├── 5dd64a1ba52f4cfdb356e82e4c3ccf571a6bf5
│   │   │   ├── 8ce8901900945cb2ce757b0e0a6c94ef77bd85
│   │   │   ├── aa70dbb4b85d605e4187eca939558b4558e9e7
│   │   │   ├── e307854d57384cf6a8361500115e8fc546e854
│   │   │   └── ebc5ed7a4499b43309988cb01ee1d650951886
│   │   ├── dd
│   │   │   ├── 25873b504c6668c25d9eaa761607b9cbe346f4
│   │   │   ├── 884c903551dbc06806986bba2c23372f3f990e
│   │   │   ├── b88a856e54481e4c064383c70936b0cf33fcc7
│   │   │   ├── c202493edf35ac0a66678346046aa67666a9fb
│   │   │   └── cd93084c0ebf72d05223c343760ed59cfd9289
│   │   ├── de
│   │   │   ├── 2cf37e286a80bc54e45768bc5302ccc0fbe938
│   │   │   ├── 7acf006ad932a15774477f2f21e0b90c14fe5f
│   │   │   ├── da33fcb07995649b9a181533b30076a7d18f77
│   │   │   └── ff6e1032ef23783e0c38416158f0e46acbb71f
│   │   ├── df
│   │   │   ├── 66995acbf1d0a9602eada6a0d1e92a07940aa5
│   │   │   ├── 67d3c8231dbdbbdfc0d2a769b531e765cc34f3
│   │   │   ├── a121608afd4e9bd91b945d6822f353f2669663
│   │   │   ├── d6e0481ff3b8ab1647288668da7edf52af0d1a
│   │   │   └── f16ec0784e1082bf133ad06c2b034705f0f2b0
│   │   ├── e0
│   │   │   ├── 3430420ee01720e95340ec446e7071951edb73
│   │   │   ├── 56b313c46a7becb70713702aca2ec217d580bc
│   │   │   └── 9afe0d7d543639ec4c89305ee126e60bd6b76d
│   │   ├── e1
│   │   │   ├── b36162426620f4f305d79b0efe218fb20dd854
│   │   │   └── ecd236c24b2c279d94d0406df1390f5a993c36
│   │   ├── e2
│   │   │   ├── 330be9e5e54eab2a4fdc1c844f3688ac2140b7
│   │   │   └── c34914a3bd99e21d362a2842f4cf1a754b368c
│   │   ├── e3
│   │   │   ├── 3854e4653027bdb23765db5577fe29f5cc14cb
│   │   │   ├── 4baa8681960f24180be7f35ce56c36f86189b6
│   │   │   ├── 64f8a0df07e4d689abb3d459572b2b5f45a74a
│   │   │   ├── 77f98a800ae20a1f77b0b62da9482bc08f40c8
│   │   │   └── cbb8a3514e5d6cd4de5865bd08dee652a5bf51
│   │   ├── e4
│   │   │   ├── ae0bec3caa6e85b93763355cc13742a24528e8
│   │   │   └── bb10c9904b874fd547e11a3adfdb2c6f70f237
│   │   ├── e5
│   │   │   └── ad10296b2a6e22d76f73f4e2c50fbf35220558
│   │   ├── e6
│   │   │   ├── 74beee49728aa20e051b12fd0ce7dd0a786db2
│   │   │   ├── 9ff2ca9aec8ea8ec63c876f0eec949a6442098
│   │   │   └── c7935248b724c6c856afb37a839c2a76c8c5fc
│   │   ├── e7
│   │   │   ├── 0be0d6673139089157bc312860f9bb2a32b70a
│   │   │   └── b7f6734ed79762a76012ffe530a59e32ba42d2
│   │   ├── e8
│   │   │   ├── 106c97b6ff247438a0cffde95f6508e55850b7
│   │   │   ├── b214a297f5ba0c2bf7bed24e4e617511fc131f
│   │   │   └── b37d7f4dfe01b022b06c63590ecdaa022a88b7
│   │   ├── e9
│   │   │   ├── e0f76c1519bf1628cae48f96b5e4ca0e34258f
│   │   │   └── ff1bb2503b55303ad4288cfefcc6017588d6a3
│   │   ├── ea
│   │   │   ├── 77962238e30fceb3f1d83c4a3e4cde90b42150
│   │   │   ├── 792e032479018dbc6e43a9a1afd1e328d84f43
│   │   │   └── f8a5968125ab43fb11af365e6d7570fee6a549
│   │   ├── eb
│   │   │   ├── 34c3cf2619951449b7e5d025dd66a94939a352
│   │   │   ├── 74bd2c9b0217c1ae05f2f676802578d3688f79
│   │   │   ├── 7aaa862c8e69fcc05a36c8177c1602cde2ea56
│   │   │   ├── 8cfdf527727b39c0c0b032297596adcd4ed14b
│   │   │   └── b0fa84a57e64474d3eb7387bab38f074c60494
│   │   ├── ec
│   │   │   ├── 275d1566fd209c7a86d44ced90efd67a5859b7
│   │   │   └── 97d860ff8fd23421f013535c01201a3b57f5c9
│   │   ├── ed
│   │   │   ├── 50e1af20c80f3abe451e1b8deb3270bd1900a3
│   │   │   ├── 64d1dbf995b0d420f984cd313f262488c4c480
│   │   │   ├── 6e3b737b27bbd653655eb98c848ad72dea7eb8
│   │   │   └── a20ed2387e013c1df0aad8573a77100b999b30
│   │   ├── ee
│   │   │   ├── 542dc156fb2a57ac6e39059df0cad8ac435cd4
│   │   │   ├── 69ed071c57048c9b860d1d3e13a7a5a53cc0d1
│   │   │   └── ac2aca7c0bb19f57d14ce75e705ff94949d84b
│   │   ├── ef
│   │   │   ├── 798b6e8d0552e7997e263d9a9b02ef36a3d1db
│   │   │   └── a17aa777fdbc39fb5b647cb647f6864adf6ba2
│   │   ├── f0
│   │   │   ├── 4c9b95243c4f575dd557338e502690e10f507e
│   │   │   └── f0902bb7bacc533bf5c13e9448ad95f65efc75
│   │   ├── f1
│   │   │   ├── 22b99782467d9f7b48efb65ce9f9d0c9c86f3e
│   │   │   ├── 3f0a1ecf7571c31bbc5c46b066e7521f6899d0
│   │   │   ├── 4241454de7b10eba2e876f79792d83d36ea21b
│   │   │   ├── 56ae51dfcaceab60c3d9268d15c2e354ffd9d6
│   │   │   ├── 7b9cc787e6f03848d1cc00b98df3fda164d5b5
│   │   │   └── cb8b17104f432deaa8aa3dbc438d30aae2f6ee
│   │   ├── f2
│   │   │   └── 11cbe410956dec88009c3593a1f68dc7419c48
│   │   ├── f3
│   │   │   ├── 0f917378b97d2a713681807cb10d6415ee6ced
│   │   │   ├── 1091089defb7cc5363234a073ed2898e51fae3
│   │   │   ├── fc06291ddb7610a5e4b5d54ef0223da34519b8
│   │   │   └── fc07b789a76b1b0560ec2ee0b8e9cea2d25e1e
│   │   ├── f4
│   │   │   ├── 2c7390a2e098e1b1a5cee2441e4ed77ba18f7f
│   │   │   ├── 39231149f0ade26b429e023681095456102e0f
│   │   │   ├── 3f5662f5c5a47ed7e962d1236631849748cbc1
│   │   │   ├── 5f75eb32437099765c52d5ab08e61ea2284dbc
│   │   │   ├── 7c15ca56d5297ea945a828a28153c73085139c
│   │   │   └── b7e7ba98025cb3914e6c517654ad024070b939
│   │   ├── f5
│   │   │   ├── 0b144b5115ca2dfbea750d51d6036d5b9e485e
│   │   │   ├── 4a1264b81f7b525ca426e55aa23fc47645613f
│   │   │   └── ed0afff1d777c8e5ee54e7afdc033924499b4d
│   │   ├── f6
│   │   │   ├── 996353c1a10b92ee136cd59e0240974174117c
│   │   │   └── c4a139f56b59246c0fb800ca617cf9355a1e33
│   │   ├── f7
│   │   │   ├── 0f54089f59d1417d01e4bf2bce9c69dddc8e88
│   │   │   ├── 1fbb3f681de5cf7fb729bd0ccd1f8b955c2bfb
│   │   │   ├── 4b9064517fd524aa8633984b079c61ed6e728b
│   │   │   ├── 9edd942fff3c0380e06a4571dfee71549925db
│   │   │   └── ee7f707559fa005defd251d78ac628cc0f057a
│   │   ├── f8
│   │   │   ├── 755c999fa5207f22126c2cfe108a80fff87087
│   │   │   ├── 7f05489e077194fb4bd3ba092b2524fb9e2f4c
│   │   │   ├── 86747179226a9fad6fbe67e977c6888949ad0c
│   │   │   └── b718d33852981fcaf05083f826795c1d514d49
│   │   ├── f9
│   │   │   └── a58ef4fe4bdadedfd58b3b941ce65e2c2ef8ab
│   │   ├── fa
│   │   │   ├── 83479f474fe118e1cae3779343ec60e6376a1c
│   │   │   ├── 8705bfb7a2acd688ebe638edd67679ef55d3c7
│   │   │   ├── ace385fb5cd72b7c286a8d35624d4a477e112a
│   │   │   ├── c7a927db334a3ed2b901f67c2cfaeca866d8df
│   │   │   ├── dbabf8acdafa2efcadcfeccdeb3914d95af52b
│   │   │   └── e27067b0a46c2af5fdec33131a8415411cbdd5
│   │   ├── fb
│   │   │   ├── 40ffdd76ed6a0e6f1ea46e5e31cd46e0efa503
│   │   │   ├── 5b50e1894746876f436c318d5b4b9c1ca7aeec
│   │   │   ├── 736ebc6aa295505f048752d418fdfc11f8296f
│   │   │   ├── 9c43c1c408688ef60234177ca761a49c0ed86d
│   │   │   └── aea0f98e89203e34314a0993b78c7cc328413f
│   │   ├── fc
│   │   │   ├── 38536efae94159e66ce0514ab389c11eee7b7c
│   │   │   ├── 4ba6d130e772a8053620a3fe33a55b5897f5d7
│   │   │   ├── a395c985be2e503fae973cbc169d6afd71dcbe
│   │   │   └── c1e38aee9ab0ee911442c2be5d6f92a896f1ac
│   │   ├── fd
│   │   │   ├── 7421e63b09bd9bd4e6a5ef0218e520e7586f30
│   │   │   ├── 982d30e980495d0c6672371b577083b84a3ff8
│   │   │   └── b0ea06c76ecde5f50bd786ae3443c748d42fa9
│   │   ├── fe
│   │   │   ├── 685e3a8b1e5802736099c6bce85710e557789a
│   │   │   └── 9bd9900357869efd463962cb1e47a2cc06c759
│   │   ├── ff
│   │   │   ├── 733e178215fbfb45a92588e3b05f48a0007f1e
│   │   │   ├── f29a871c7f57a712b504b53a95d577c4a853a5
│   │   │   └── f3a08db6e2011c39c7da51755bc5007b8fddec
│   │   ├── info
│   │   └── pack
│   │       ├── pack-023342184687293055039d6fe349f873628caa51.idx
│   │       ├── pack-023342184687293055039d6fe349f873628caa51.pack
│   │       ├── pack-93a01823e0167791130be9a7ce85f04d19691a27.idx
│   │       └── pack-93a01823e0167791130be9a7ce85f04d19691a27.pack
│   ├── ORIG_HEAD
│   ├── packed-refs
│   └── refs
│       ├── heads
│       │   └── master
│       ├── remotes
│       │   └── origin
│       │       ├── HEAD
│       │       └── master
│       └── tags
├── istio
│   └── 1-setup-env.sh
├── kindenv
│   ├── ingress-controller
│   │   ├── 1-http
│   │   │   ├── 1-setup-env.sh
│   │   │   ├── 2-ingress
│   │   │   │   ├── 1-metallb.yaml
│   │   │   │   ├── 2-l2-config.yaml
│   │   │   │   ├── 3-deploy-nginx-ingress.yaml
│   │   │   │   ├── 4-Ingress-rule.yaml
│   │   │   │   ├── 5-svc-backend.yaml
│   │   │   │   └── 6-test.sh
│   │   │   ├── calico.yaml
│   │   │   ├── http-tcp-three-handways.log
│   │   │   └── http-tcp-three-handways.log-details.txt
│   │   └── 2-https-with-cert-manager
│   │       ├── 1-setup-env.sh
│   │       ├── 2-cert-env-prep
│   │       │   ├── 1-cert-manager.yaml
│   │       │   ├── 2-cert-ready.yaml
│   │       │   ├── 3-assgin_ca.yaml
│   │       │   └── ReadME.html
│   │       ├── 3-ingress
│   │       │   ├── 1-metallb.yaml
│   │       │   ├── 2-l2-config.yaml
│   │       │   ├── 3-deploy-nginx-ingress.yaml
│   │       │   ├── 4-Ingress-rule.yaml
│   │       │   ├── 5-svc-backend.yaml
│   │       │   └── 6-test.sh
│   │       └── calico.yaml
│   ├── kindnet-base
│   │   └── 1-setup-env
│   │       ├── 1-setup-env.sh
│   │       ├── calico.yaml
│   │       └── cni.yaml
│   ├── kubeshark
│   │   └── 1-kind-calico-ipip
│   │       ├── 1-setup-env.sh
│   │       ├── calico.yaml
│   │       └── cni.yaml
│   ├── kubevela
│   │   ├── 1-setup-env.sh
│   │   ├── 2-ingress-controller
│   │   │   └── ingress
│   │   │       ├── 1-metallb.yaml
│   │   │       ├── 2-l2-config.yaml
│   │   │       └── 3-deploy-nginx-ingress.yaml
│   │   ├── 3-install-kubevela.sh
│   │   ├── 4-demo.sh
│   │   ├── calico.yaml
│   │   ├── vela-app.yaml
│   │   └── vela-core-1.7.6.tgz
│   └── metallb
│       ├── 1-setup-env.sh
│       ├── 2-metallb.yaml
│       ├── 3-metallb-l2-config.yaml
│       ├── calico.yaml
│       └── cni.yaml
├── kubeovn
│   ├── 1-setup-env.sh
│   ├── cni.yaml
│   ├── install.sh
│   ├── kube-ovn-crd.yaml
│   ├── kube-ovn.yaml
│   └── ovn.yaml
├── Lac.rs
├── muticni
│   ├── 1-kind-multus-macvlan
│   │   ├── 1-setup-env.sh
│   │   ├── 2-install-multus-whereabouts.sh
│   │   ├── 3-deploy-macvlan-testpods.sh
│   │   ├── 4-gc-resource.sh
│   │   ├── calico.yaml
│   │   ├── multus-cni
│   │   │   ├── cmd
│   │   │   │   ├── multus
│   │   │   │   │   └── main.go
│   │   │   │   ├── multus-daemon
│   │   │   │   │   └── main.go
│   │   │   │   └── multus-shim
│   │   │   │       └── main.go
│   │   │   ├── CODE_OF_CONDUCT.md
│   │   │   ├── CONTRIBUTING.md
│   │   │   ├── deployments
│   │   │   │   ├── deprecated
│   │   │   │   │   ├── multus-daemonset-crio-pre1.16.yml
│   │   │   │   │   ├── multus-daemonset-gke-pre-1.16.yml
│   │   │   │   │   └── multus-daemonset-pre-1.16.yml
│   │   │   │   ├── multus-daemonset-crio.yml
│   │   │   │   ├── multus-daemonset-gke-1.16.yml
│   │   │   │   ├── multus-daemonset-thick.yml
│   │   │   │   └── multus-daemonset.yml
│   │   │   ├── docs
│   │   │   │   ├── configuration.md
│   │   │   │   ├── development.md
│   │   │   │   ├── how-to-use.md
│   │   │   │   ├── images
│   │   │   │   │   ├── multus_cni_pod.png
│   │   │   │   │   ├── multus_crd_usage_diagram.JPG
│   │   │   │   │   ├── Multus.png
│   │   │   │   │   ├── multus-pod-image.svg
│   │   │   │   │   └── workflow.png
│   │   │   │   ├── node-kubeconfig.yaml
│   │   │   │   ├── quickstart.md
│   │   │   │   └── thick-plugin.md
│   │   │   ├── e2e
│   │   │   │   ├── generate_yamls.sh
│   │   │   │   ├── get_tools.sh
│   │   │   │   ├── README.md
│   │   │   │   ├── setup_cluster.sh
│   │   │   │   ├── simple-static-pod.yml
│   │   │   │   ├── static-pod-nad.yml
│   │   │   │   ├── teardown.sh
│   │   │   │   ├── templates
│   │   │   │   │   ├── cni-install.yml.j2
│   │   │   │   │   ├── default-route1.yml.j2
│   │   │   │   │   ├── multus-daemonset-thick.yml.j2
│   │   │   │   │   ├── multus-daemonset.yml.j2
│   │   │   │   │   ├── simple-macvlan1.yml.j2
│   │   │   │   │   └── simple-pod.yml.j2
│   │   │   │   ├── test-default-route1.sh
│   │   │   │   ├── test-simple-macvlan1.sh
│   │   │   │   ├── test-simple-pod.sh
│   │   │   │   └── test-static-pod.sh
│   │   │   ├── examples
│   │   │   │   ├── macvlan-pod.yml
│   │   │   │   ├── README.md
│   │   │   │   └── sriov-pod.yml
│   │   │   ├── .github
│   │   │   │   ├── ISSUE_TEMPLATE
│   │   │   │   │   ├── bug-report.md
│   │   │   │   │   ├── enhancement.md
│   │   │   │   │   └── support.md
│   │   │   │   └── workflows
│   │   │   │       ├── build.yml
│   │   │   │       ├── image-build.yml
│   │   │   │       ├── image-push-master.yml
│   │   │   │       ├── image-push-release.yml
│   │   │   │       ├── kind-e2e.yml
│   │   │   │       ├── release.yml
│   │   │   │       ├── stale-issues-prs.yml
│   │   │   │       └── test.yml
│   │   │   ├── .gitignore
│   │   │   ├── go.mod
│   │   │   ├── .goreleaser.yml
│   │   │   ├── go.sum
│   │   │   ├── hack
│   │   │   │   ├── build-go.sh
│   │   │   │   └── test-go.sh
│   │   │   ├── images
│   │   │   │   ├── Dockerfile
│   │   │   │   ├── Dockerfile.arm32
│   │   │   │   ├── Dockerfile.arm64
│   │   │   │   ├── Dockerfile.openshift
│   │   │   │   ├── Dockerfile.ppc64le
│   │   │   │   ├── Dockerfile.s390x
│   │   │   │   ├── Dockerfile.thick
│   │   │   │   ├── entrypoint.sh
│   │   │   │   └── README.md
│   │   │   ├── LICENSE
│   │   │   ├── pkg
│   │   │   │   ├── checkpoint
│   │   │   │   │   ├── checkpoint.go
│   │   │   │   │   ├── checkpoint_test.go
│   │   │   │   │   └── doc.go
│   │   │   │   ├── k8sclient
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── k8sclient.go
│   │   │   │   │   └── k8sclient_test.go
│   │   │   │   ├── kubeletclient
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── kubeletclient.go
│   │   │   │   │   └── kubeletclient_test.go
│   │   │   │   ├── logging
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── logging.go
│   │   │   │   │   └── logging_test.go
│   │   │   │   ├── multus
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── multus_cni020_test.go
│   │   │   │   │   ├── multus_cni040_test.go
│   │   │   │   │   ├── multus_cni100_test.go
│   │   │   │   │   ├── multus.go
│   │   │   │   │   └── multus_suite_test.go
│   │   │   │   ├── netutils
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── netutils.go
│   │   │   │   │   └── netutils_test.go
│   │   │   │   ├── server
│   │   │   │   │   ├── api
│   │   │   │   │   │   ├── api.go
│   │   │   │   │   │   ├── doc.go
│   │   │   │   │   │   ├── shim.go
│   │   │   │   │   │   ├── socket.go
│   │   │   │   │   │   └── types.go
│   │   │   │   │   ├── config
│   │   │   │   │   │   ├── config_suite_test.go
│   │   │   │   │   │   ├── doc.go
│   │   │   │   │   │   ├── generator.go
│   │   │   │   │   │   ├── generator_test.go
│   │   │   │   │   │   ├── manager.go
│   │   │   │   │   │   └── manager_test.go
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── exec_chroot.go
│   │   │   │   │   ├── exec_chroot_test.go
│   │   │   │   │   ├── server.go
│   │   │   │   │   ├── server_suite_test.go
│   │   │   │   │   ├── thick_cni_test.go
│   │   │   │   │   └── types.go
│   │   │   │   ├── testing
│   │   │   │   │   ├── doc.go
│   │   │   │   │   └── testing.go
│   │   │   │   └── types
│   │   │   │       ├── conf.go
│   │   │   │       ├── conf_test.go
│   │   │   │       ├── doc.go
│   │   │   │       └── types.go
│   │   │   ├── README.md
│   │   │   └── .travis.yml
│   │   └── whereabouts
│   │       ├── cmd
│   │       │   ├── controlloop
│   │       │   │   └── controlloop.go
│   │       │   ├── whereabouts.go
│   │       │   └── whereabouts_test.go
│   │       ├── doc
│   │       │   ├── crds
│   │       │   │   ├── daemonset-install.yaml
│   │       │   │   ├── whereabouts.cni.cncf.io_ippools.yaml
│   │       │   │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
│   │       │   ├── developer_notes.md
│   │       │   ├── extended-configuration.md
│   │       │   ├── logo.png
│   │       │   ├── logo-sticker.svg
│   │       │   ├── logo.svg
│   │       │   ├── proposals
│   │       │   │   └── dualstack.md
│   │       │   └── sample_config.json
│   │       ├── Dockerfile
│   │       ├── Dockerfile.arm64
│   │       ├── Dockerfile.openshift
│   │       ├── e2e
│   │       │   ├── client
│   │       │   │   ├── ippool.go
│   │       │   │   ├── pod.go
│   │       │   │   ├── replicaset.go
│   │       │   │   ├── statefulset.go
│   │       │   │   └── whereabouts.go
│   │       │   ├── e2e_test.go
│   │       │   ├── entities
│   │       │   │   ├── generators.go
│   │       │   │   └── helpers.go
│   │       │   ├── poolconsistency
│   │       │   │   ├── checker.go
│   │       │   │   └── poolconsistency_test.go
│   │       │   ├── retrievers
│   │       │   │   └── pod.go
│   │       │   └── testenvironment
│   │       │       └── config.go
│   │       ├── .github
│   │       │   ├── CODEOWNERS
│   │       │   ├── ISSUE_TEMPLATE
│   │       │   │   ├── bug_report.md
│   │       │   │   └── feature_request.md
│   │       │   ├── PULL_REQUEST_TEMPLATE.md
│   │       │   └── workflows
│   │       │       ├── binaries-upload-release.yml
│   │       │       ├── build.yml
│   │       │       ├── image-build.yml
│   │       │       ├── image-push-master.yml
│   │       │       ├── image-push-release.yml
│   │       │       └── test.yml
│   │       ├── .gitignore
│   │       ├── go.mod
│   │       ├── go.sum
│   │       ├── hack
│   │       │   ├── boilerplate.go.txt
│   │       │   ├── build-go.sh
│   │       │   ├── cni-install.yml
│   │       │   ├── e2e-get-test-tools.sh
│   │       │   ├── e2e-setup-kind-cluster.sh
│   │       │   ├── generate-code.sh
│   │       │   ├── install-kubebuilder-tools.sh
│   │       │   ├── test-go.sh
│   │       │   ├── update-codegen.sh
│   │       │   ├── update-deps.sh
│   │       │   └── verify-codegen.sh
│   │       ├── LICENSE
│   │       ├── Makefile
│   │       ├── pkg
│   │       │   ├── allocate
│   │       │   │   ├── allocate.go
│   │       │   │   └── allocate_test.go
│   │       │   ├── api
│   │       │   │   └── whereabouts.cni.cncf.io
│   │       │   │       ├── register.go
│   │       │   │       └── v1alpha1
│   │       │   │           ├── doc.go
│   │       │   │           ├── ippool_types.go
│   │       │   │           ├── overlappingrangeipreservation_types.go
│   │       │   │           ├── register.go
│   │       │   │           └── zz_generated.deepcopy.go
│   │       │   ├── client
│   │       │   │   ├── clientset
│   │       │   │   │   └── versioned
│   │       │   │   │       ├── clientset.go
│   │       │   │   │       ├── doc.go
│   │       │   │   │       ├── fake
│   │       │   │   │       │   ├── clientset_generated.go
│   │       │   │   │       │   ├── doc.go
│   │       │   │   │       │   └── register.go
│   │       │   │   │       ├── scheme
│   │       │   │   │       │   ├── doc.go
│   │       │   │   │       │   └── register.go
│   │       │   │   │       └── typed
│   │       │   │   │           └── whereabouts.cni.cncf.io
│   │       │   │   │               └── v1alpha1
│   │       │   │   │                   ├── doc.go
│   │       │   │   │                   ├── fake
│   │       │   │   │                   │   ├── doc.go
│   │       │   │   │                   │   ├── fake_ippool.go
│   │       │   │   │                   │   ├── fake_overlappingrangeipreservation.go
│   │       │   │   │                   │   └── fake_whereabouts.cni.cncf.io_client.go
│   │       │   │   │                   ├── generated_expansion.go
│   │       │   │   │                   ├── ippool.go
│   │       │   │   │                   ├── overlappingrangeipreservation.go
│   │       │   │   │                   └── whereabouts.cni.cncf.io_client.go
│   │       │   │   ├── informers
│   │       │   │   │   └── externalversions
│   │       │   │   │       ├── factory.go
│   │       │   │   │       ├── generic.go
│   │       │   │   │       ├── internalinterfaces
│   │       │   │   │       │   └── factory_interfaces.go
│   │       │   │   │       └── whereabouts.cni.cncf.io
│   │       │   │   │           ├── interface.go
│   │       │   │   │           └── v1alpha1
│   │       │   │   │               ├── interface.go
│   │       │   │   │               ├── ippool.go
│   │       │   │   │               └── overlappingrangeipreservation.go
│   │       │   │   └── listers
│   │       │   │       └── whereabouts.cni.cncf.io
│   │       │   │           └── v1alpha1
│   │       │   │               ├── expansion_generated.go
│   │       │   │               ├── ippool.go
│   │       │   │               └── overlappingrangeipreservation.go
│   │       │   ├── config
│   │       │   │   ├── config.go
│   │       │   │   └── config_test.go
│   │       │   ├── controlloop
│   │       │   │   ├── dummy_controller.go
│   │       │   │   ├── entity_generators.go
│   │       │   │   ├── pod_controller_test.go
│   │       │   │   └── pod.go
│   │       │   ├── logging
│   │       │   │   ├── logging.go
│   │       │   │   └── logging_test.go
│   │       │   ├── reconciler
│   │       │   │   ├── ip.go
│   │       │   │   ├── iploop.go
│   │       │   │   ├── ip_test.go
│   │       │   │   ├── wrappedPod.go
│   │       │   │   └── wrappedPod_test.go
│   │       │   ├── storage
│   │       │   │   ├── kubernetes
│   │       │   │   │   ├── client.go
│   │       │   │   │   ├── errors.go
│   │       │   │   │   └── ipam.go
│   │       │   │   ├── storage.go
│   │       │   │   └── storage_test.go
│   │       │   ├── types
│   │       │   │   ├── ipsanitizers.go
│   │       │   │   └── types.go
│   │       │   └── version
│   │       │       ├── doc.go
│   │       │       └── version.go
│   │       ├── README.md
│   │       ├── script
│   │       │   └── install-cni.sh
│   │       └── tools.go
│   ├── 2-kind-multus-macvlan-sbr
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 3-install-multus-whereabouts.sh
│   │   ├── 4-deploy-macvlan-sbr-testpods.sh
│   │   ├── 5-test-macvlan-with-sbr.sh
│   │   ├── 6-reference
│   │   │   └── Microk8s - Multus Networking – ZenCoffee Blog – random notes, guides, and thoughts… (12_14_2022 11_25_53 AM).html
│   │   ├── calico.yaml
│   │   ├── clab-calico-ipip
│   │   │   ├── ansible-inventory.yml
│   │   │   ├── authorized_keys
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yml.bak
│   │   ├── multus-cni
│   │   │   ├── cmd
│   │   │   │   ├── multus
│   │   │   │   │   └── main.go
│   │   │   │   ├── multus-daemon
│   │   │   │   │   └── main.go
│   │   │   │   └── multus-shim
│   │   │   │       └── main.go
│   │   │   ├── CODE_OF_CONDUCT.md
│   │   │   ├── CONTRIBUTING.md
│   │   │   ├── deployments
│   │   │   │   ├── deprecated
│   │   │   │   │   ├── multus-daemonset-crio-pre1.16.yml
│   │   │   │   │   ├── multus-daemonset-gke-pre-1.16.yml
│   │   │   │   │   └── multus-daemonset-pre-1.16.yml
│   │   │   │   ├── multus-daemonset-crio.yml
│   │   │   │   ├── multus-daemonset-gke-1.16.yml
│   │   │   │   ├── multus-daemonset-thick.yml
│   │   │   │   └── multus-daemonset.yml
│   │   │   ├── docs
│   │   │   │   ├── configuration.md
│   │   │   │   ├── development.md
│   │   │   │   ├── how-to-use.md
│   │   │   │   ├── images
│   │   │   │   │   ├── multus_cni_pod.png
│   │   │   │   │   ├── multus_crd_usage_diagram.JPG
│   │   │   │   │   ├── Multus.png
│   │   │   │   │   ├── multus-pod-image.svg
│   │   │   │   │   └── workflow.png
│   │   │   │   ├── node-kubeconfig.yaml
│   │   │   │   ├── quickstart.md
│   │   │   │   └── thick-plugin.md
│   │   │   ├── e2e
│   │   │   │   ├── generate_yamls.sh
│   │   │   │   ├── get_tools.sh
│   │   │   │   ├── README.md
│   │   │   │   ├── setup_cluster.sh
│   │   │   │   ├── simple-static-pod.yml
│   │   │   │   ├── static-pod-nad.yml
│   │   │   │   ├── teardown.sh
│   │   │   │   ├── templates
│   │   │   │   │   ├── cni-install.yml.j2
│   │   │   │   │   ├── default-route1.yml.j2
│   │   │   │   │   ├── multus-daemonset-thick.yml.j2
│   │   │   │   │   ├── multus-daemonset.yml.j2
│   │   │   │   │   ├── simple-macvlan1.yml.j2
│   │   │   │   │   └── simple-pod.yml.j2
│   │   │   │   ├── test-default-route1.sh
│   │   │   │   ├── test-simple-macvlan1.sh
│   │   │   │   ├── test-simple-pod.sh
│   │   │   │   └── test-static-pod.sh
│   │   │   ├── examples
│   │   │   │   ├── macvlan-pod.yml
│   │   │   │   ├── README.md
│   │   │   │   └── sriov-pod.yml
│   │   │   ├── .github
│   │   │   │   ├── ISSUE_TEMPLATE
│   │   │   │   │   ├── bug-report.md
│   │   │   │   │   ├── enhancement.md
│   │   │   │   │   └── support.md
│   │   │   │   └── workflows
│   │   │   │       ├── build.yml
│   │   │   │       ├── image-build.yml
│   │   │   │       ├── image-push-master.yml
│   │   │   │       ├── image-push-release.yml
│   │   │   │       ├── kind-e2e.yml
│   │   │   │       ├── release.yml
│   │   │   │       ├── stale-issues-prs.yml
│   │   │   │       └── test.yml
│   │   │   ├── .gitignore
│   │   │   ├── go.mod
│   │   │   ├── .goreleaser.yml
│   │   │   ├── go.sum
│   │   │   ├── hack
│   │   │   │   ├── build-go.sh
│   │   │   │   └── test-go.sh
│   │   │   ├── images
│   │   │   │   ├── Dockerfile
│   │   │   │   ├── Dockerfile.arm32
│   │   │   │   ├── Dockerfile.arm64
│   │   │   │   ├── Dockerfile.openshift
│   │   │   │   ├── Dockerfile.ppc64le
│   │   │   │   ├── Dockerfile.s390x
│   │   │   │   ├── Dockerfile.thick
│   │   │   │   ├── entrypoint.sh
│   │   │   │   └── README.md
│   │   │   ├── LICENSE
│   │   │   ├── pkg
│   │   │   │   ├── checkpoint
│   │   │   │   │   ├── checkpoint.go
│   │   │   │   │   ├── checkpoint_test.go
│   │   │   │   │   └── doc.go
│   │   │   │   ├── k8sclient
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── k8sclient.go
│   │   │   │   │   └── k8sclient_test.go
│   │   │   │   ├── kubeletclient
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── kubeletclient.go
│   │   │   │   │   └── kubeletclient_test.go
│   │   │   │   ├── logging
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── logging.go
│   │   │   │   │   └── logging_test.go
│   │   │   │   ├── multus
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── multus_cni020_test.go
│   │   │   │   │   ├── multus_cni040_test.go
│   │   │   │   │   ├── multus_cni100_test.go
│   │   │   │   │   ├── multus.go
│   │   │   │   │   └── multus_suite_test.go
│   │   │   │   ├── netutils
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── netutils.go
│   │   │   │   │   └── netutils_test.go
│   │   │   │   ├── server
│   │   │   │   │   ├── api
│   │   │   │   │   │   ├── api.go
│   │   │   │   │   │   ├── doc.go
│   │   │   │   │   │   ├── shim.go
│   │   │   │   │   │   ├── socket.go
│   │   │   │   │   │   └── types.go
│   │   │   │   │   ├── config
│   │   │   │   │   │   ├── config_suite_test.go
│   │   │   │   │   │   ├── doc.go
│   │   │   │   │   │   ├── generator.go
│   │   │   │   │   │   ├── generator_test.go
│   │   │   │   │   │   ├── manager.go
│   │   │   │   │   │   └── manager_test.go
│   │   │   │   │   ├── doc.go
│   │   │   │   │   ├── exec_chroot.go
│   │   │   │   │   ├── exec_chroot_test.go
│   │   │   │   │   ├── server.go
│   │   │   │   │   ├── server_suite_test.go
│   │   │   │   │   ├── thick_cni_test.go
│   │   │   │   │   └── types.go
│   │   │   │   ├── testing
│   │   │   │   │   ├── doc.go
│   │   │   │   │   └── testing.go
│   │   │   │   └── types
│   │   │   │       ├── conf.go
│   │   │   │       ├── conf_test.go
│   │   │   │       ├── doc.go
│   │   │   │       └── types.go
│   │   │   ├── README.md
│   │   │   └── .travis.yml
│   │   ├── startup-conf
│   │   │   ├── gw0-boot.cfg
│   │   │   └── gw0.cfg
│   │   └── whereabouts
│   │       ├── cmd
│   │       │   ├── controlloop
│   │       │   │   └── controlloop.go
│   │       │   ├── whereabouts.go
│   │       │   └── whereabouts_test.go
│   │       ├── doc
│   │       │   ├── crds
│   │       │   │   ├── daemonset-install.yaml
│   │       │   │   ├── whereabouts.cni.cncf.io_ippools.yaml
│   │       │   │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
│   │       │   ├── developer_notes.md
│   │       │   ├── extended-configuration.md
│   │       │   ├── logo.png
│   │       │   ├── logo-sticker.svg
│   │       │   ├── logo.svg
│   │       │   ├── proposals
│   │       │   │   └── dualstack.md
│   │       │   └── sample_config.json
│   │       ├── Dockerfile
│   │       ├── Dockerfile.arm64
│   │       ├── Dockerfile.openshift
│   │       ├── e2e
│   │       │   ├── client
│   │       │   │   ├── ippool.go
│   │       │   │   ├── pod.go
│   │       │   │   ├── replicaset.go
│   │       │   │   ├── statefulset.go
│   │       │   │   └── whereabouts.go
│   │       │   ├── e2e_test.go
│   │       │   ├── entities
│   │       │   │   ├── generators.go
│   │       │   │   └── helpers.go
│   │       │   ├── poolconsistency
│   │       │   │   ├── checker.go
│   │       │   │   └── poolconsistency_test.go
│   │       │   ├── retrievers
│   │       │   │   └── pod.go
│   │       │   └── testenvironment
│   │       │       └── config.go
│   │       ├── .github
│   │       │   ├── CODEOWNERS
│   │       │   ├── ISSUE_TEMPLATE
│   │       │   │   ├── bug_report.md
│   │       │   │   └── feature_request.md
│   │       │   ├── PULL_REQUEST_TEMPLATE.md
│   │       │   └── workflows
│   │       │       ├── binaries-upload-release.yml
│   │       │       ├── build.yml
│   │       │       ├── image-build.yml
│   │       │       ├── image-push-master.yml
│   │       │       ├── image-push-release.yml
│   │       │       └── test.yml
│   │       ├── .gitignore
│   │       ├── go.mod
│   │       ├── go.sum
│   │       ├── hack
│   │       │   ├── boilerplate.go.txt
│   │       │   ├── build-go.sh
│   │       │   ├── cni-install.yml
│   │       │   ├── e2e-get-test-tools.sh
│   │       │   ├── e2e-setup-kind-cluster.sh
│   │       │   ├── generate-code.sh
│   │       │   ├── install-kubebuilder-tools.sh
│   │       │   ├── test-go.sh
│   │       │   ├── update-codegen.sh
│   │       │   ├── update-deps.sh
│   │       │   └── verify-codegen.sh
│   │       ├── LICENSE
│   │       ├── Makefile
│   │       ├── pkg
│   │       │   ├── allocate
│   │       │   │   ├── allocate.go
│   │       │   │   └── allocate_test.go
│   │       │   ├── api
│   │       │   │   └── whereabouts.cni.cncf.io
│   │       │   │       ├── register.go
│   │       │   │       └── v1alpha1
│   │       │   │           ├── doc.go
│   │       │   │           ├── ippool_types.go
│   │       │   │           ├── overlappingrangeipreservation_types.go
│   │       │   │           ├── register.go
│   │       │   │           └── zz_generated.deepcopy.go
│   │       │   ├── client
│   │       │   │   ├── clientset
│   │       │   │   │   └── versioned
│   │       │   │   │       ├── clientset.go
│   │       │   │   │       ├── doc.go
│   │       │   │   │       ├── fake
│   │       │   │   │       │   ├── clientset_generated.go
│   │       │   │   │       │   ├── doc.go
│   │       │   │   │       │   └── register.go
│   │       │   │   │       ├── scheme
│   │       │   │   │       │   ├── doc.go
│   │       │   │   │       │   └── register.go
│   │       │   │   │       └── typed
│   │       │   │   │           └── whereabouts.cni.cncf.io
│   │       │   │   │               └── v1alpha1
│   │       │   │   │                   ├── doc.go
│   │       │   │   │                   ├── fake
│   │       │   │   │                   │   ├── doc.go
│   │       │   │   │                   │   ├── fake_ippool.go
│   │       │   │   │                   │   ├── fake_overlappingrangeipreservation.go
│   │       │   │   │                   │   └── fake_whereabouts.cni.cncf.io_client.go
│   │       │   │   │                   ├── generated_expansion.go
│   │       │   │   │                   ├── ippool.go
│   │       │   │   │                   ├── overlappingrangeipreservation.go
│   │       │   │   │                   └── whereabouts.cni.cncf.io_client.go
│   │       │   │   ├── informers
│   │       │   │   │   └── externalversions
│   │       │   │   │       ├── factory.go
│   │       │   │   │       ├── generic.go
│   │       │   │   │       ├── internalinterfaces
│   │       │   │   │       │   └── factory_interfaces.go
│   │       │   │   │       └── whereabouts.cni.cncf.io
│   │       │   │   │           ├── interface.go
│   │       │   │   │           └── v1alpha1
│   │       │   │   │               ├── interface.go
│   │       │   │   │               ├── ippool.go
│   │       │   │   │               └── overlappingrangeipreservation.go
│   │       │   │   └── listers
│   │       │   │       └── whereabouts.cni.cncf.io
│   │       │   │           └── v1alpha1
│   │       │   │               ├── expansion_generated.go
│   │       │   │               ├── ippool.go
│   │       │   │               └── overlappingrangeipreservation.go
│   │       │   ├── config
│   │       │   │   ├── config.go
│   │       │   │   └── config_test.go
│   │       │   ├── controlloop
│   │       │   │   ├── dummy_controller.go
│   │       │   │   ├── entity_generators.go
│   │       │   │   ├── pod_controller_test.go
│   │       │   │   └── pod.go
│   │       │   ├── logging
│   │       │   │   ├── logging.go
│   │       │   │   └── logging_test.go
│   │       │   ├── reconciler
│   │       │   │   ├── ip.go
│   │       │   │   ├── iploop.go
│   │       │   │   ├── ip_test.go
│   │       │   │   ├── wrappedPod.go
│   │       │   │   └── wrappedPod_test.go
│   │       │   ├── storage
│   │       │   │   ├── kubernetes
│   │       │   │   │   ├── client.go
│   │       │   │   │   ├── errors.go
│   │       │   │   │   └── ipam.go
│   │       │   │   ├── storage.go
│   │       │   │   └── storage_test.go
│   │       │   ├── types
│   │       │   │   ├── ipsanitizers.go
│   │       │   │   └── types.go
│   │       │   └── version
│   │       │       ├── doc.go
│   │       │       └── version.go
│   │       ├── README.md
│   │       ├── script
│   │       │   └── install-cni.sh
│   │       └── tools.go
│   ├── 3-kind-multus-ipvlanl2
│   │   ├── 1-setup-env.sh
│   │   ├── 2-install-multus-whereabouts.sh
│   │   ├── 3-deploy-ipvlan-testpods.sh
│   │   ├── 4-test-ipvlanl2.sh
│   │   ├── 5-gc-resource.sh
│   │   ├── calico.yaml
│   │   ├── multus-cni
│   │   │   ├── deployments
│   │   │   │   └── multus-daemonset.yml
│   │   │   ├── .github
│   │   │   │   ├── ISSUE_TEMPLATE
│   │   │   │   │   ├── bug-report.md
│   │   │   │   │   ├── enhancement.md
│   │   │   │   │   └── support.md
│   │   │   │   └── workflows
│   │   │   │       ├── build.yml
│   │   │   │       ├── image-build.yml
│   │   │   │       ├── image-push-master.yml
│   │   │   │       ├── image-push-release.yml
│   │   │   │       ├── kind-e2e.yml
│   │   │   │       ├── release.yml
│   │   │   │       ├── stale-issues-prs.yml
│   │   │   │       └── test.yml
│   │   │   ├── .gitignore
│   │   │   ├── .goreleaser.yml
│   │   │   ├── README.md
│   │   │   └── .travis.yml
│   │   └── whereabouts
│   │       ├── doc
│   │       │   ├── crds
│   │       │   │   ├── daemonset-install.yaml
│   │       │   │   ├── whereabouts.cni.cncf.io_ippools.yaml
│   │       │   │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
│   │       │   └── sample_config.json
│   │       ├── .github
│   │       │   ├── CODEOWNERS
│   │       │   ├── ISSUE_TEMPLATE
│   │       │   │   ├── bug_report.md
│   │       │   │   └── feature_request.md
│   │       │   ├── PULL_REQUEST_TEMPLATE.md
│   │       │   └── workflows
│   │       │       ├── binaries-upload-release.yml
│   │       │       ├── build.yml
│   │       │       ├── image-build.yml
│   │       │       ├── image-push-master.yml
│   │       │       ├── image-push-release.yml
│   │       │       └── test.yml
│   │       ├── .gitignore
│   │       └── README.md
│   ├── 4-kind-multus-ipvlanl2-sbr
│   │   ├── 1-setup-env.sh
│   │   ├── 2-install-multus-whereabouts.sh
│   │   ├── 3-deploy-ipvlan-with-sbr-testpods.sh
│   │   ├── 4-test-ipvlan-with-sbr.sh
│   │   ├── 5-same-L2-SBR-priority.sh
│   │   ├── 6-same-L2-both-SBR-priority.sh
│   │   ├── 7-reference
│   │   │   └── Microk8s - Multus Networking – ZenCoffee Blog – random notes, guides, and thoughts… (12_14_2022 11_25_53 AM).html
│   │   ├── calico.yaml
│   │   ├── multus-cni
│   │   │   ├── deployments
│   │   │   │   └── multus-daemonset.yml
│   │   │   ├── .github
│   │   │   │   ├── ISSUE_TEMPLATE
│   │   │   │   │   ├── bug-report.md
│   │   │   │   │   ├── enhancement.md
│   │   │   │   │   └── support.md
│   │   │   │   └── workflows
│   │   │   │       ├── build.yml
│   │   │   │       ├── image-build.yml
│   │   │   │       ├── image-push-master.yml
│   │   │   │       ├── image-push-release.yml
│   │   │   │       ├── kind-e2e.yml
│   │   │   │       ├── release.yml
│   │   │   │       ├── stale-issues-prs.yml
│   │   │   │       └── test.yml
│   │   │   ├── .gitignore
│   │   │   ├── .goreleaser.yml
│   │   │   ├── README.md
│   │   │   └── .travis.yml
│   │   ├── whereabouts
│   │   │   ├── doc
│   │   │   │   ├── crds
│   │   │   │   │   ├── daemonset-install.yaml
│   │   │   │   │   ├── whereabouts.cni.cncf.io_ippools.yaml
│   │   │   │   │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
│   │   │   │   └── sample_config.json
│   │   │   ├── .github
│   │   │   │   ├── CODEOWNERS
│   │   │   │   ├── ISSUE_TEMPLATE
│   │   │   │   │   ├── bug_report.md
│   │   │   │   │   └── feature_request.md
│   │   │   │   ├── PULL_REQUEST_TEMPLATE.md
│   │   │   │   └── workflows
│   │   │   │       ├── binaries-upload-release.yml
│   │   │   │       ├── build.yml
│   │   │   │       ├── image-build.yml
│   │   │   │       ├── image-push-master.yml
│   │   │   │       ├── image-push-release.yml
│   │   │   │       └── test.yml
│   │   │   ├── .gitignore
│   │   │   └── README.md
│   │   └── x-cetnos.sh
│   ├── 5-kind-multus-ipvlanl3
│   │   ├── 1-setup-env.sh
│   │   ├── 2-install-multus-whereabouts.sh
│   │   ├── 3-deploy-ipvlan-testpods.sh
│   │   ├── 4-test-ipvlanl3.sh
│   │   ├── 5-gc-resource.sh
│   │   ├── 6-reference
│   │   │   └── ipvlan-l3.sh
│   │   ├── calico.yaml
│   │   ├── multus-cni
│   │   │   ├── deployments
│   │   │   │   └── multus-daemonset.yml
│   │   │   ├── .github
│   │   │   │   ├── ISSUE_TEMPLATE
│   │   │   │   │   ├── bug-report.md
│   │   │   │   │   ├── enhancement.md
│   │   │   │   │   └── support.md
│   │   │   │   └── workflows
│   │   │   │       ├── build.yml
│   │   │   │       ├── image-build.yml
│   │   │   │       ├── image-push-master.yml
│   │   │   │       ├── image-push-release.yml
│   │   │   │       ├── kind-e2e.yml
│   │   │   │       ├── release.yml
│   │   │   │       ├── stale-issues-prs.yml
│   │   │   │       └── test.yml
│   │   │   ├── .gitignore
│   │   │   ├── .goreleaser.yml
│   │   │   ├── README.md
│   │   │   └── .travis.yml
│   │   └── whereabouts
│   │       ├── doc
│   │       │   ├── crds
│   │       │   │   ├── daemonset-install.yaml
│   │       │   │   ├── whereabouts.cni.cncf.io_ippools.yaml
│   │       │   │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
│   │       │   └── sample_config.json
│   │       ├── .github
│   │       │   ├── CODEOWNERS
│   │       │   ├── ISSUE_TEMPLATE
│   │       │   │   ├── bug_report.md
│   │       │   │   └── feature_request.md
│   │       │   ├── PULL_REQUEST_TEMPLATE.md
│   │       │   └── workflows
│   │       │       ├── binaries-upload-release.yml
│   │       │       ├── build.yml
│   │       │       ├── image-build.yml
│   │       │       ├── image-push-master.yml
│   │       │       ├── image-push-release.yml
│   │       │       └── test.yml
│   │       ├── .gitignore
│   │       └── README.md
│   ├── 6-multus-sriov-kernel
│   │   ├── Enable-SRIOV-Kernel.html
│   │   └── How-to-enable-SRIOV-Kernel.YAML
│   ├── 7-multus-sriov-dpdk-vpp
│   │   ├── Enable-SRIOV-DPDK-VPP.html
│   │   └── How-to-enable-SRIOV-DPDK-VPP.YAML
│   └── 9-multus-af-xdp
│       ├── Daemonset
│       │   ├── DMScdq.yaml
│       │   └── DMSprimary.yaml
│       ├── NAD
│       │   └── EastWest.yaml
│       └── POD
│           ├── afxdp-podspec.yaml
│           └── l2fwd-1NIC.yaml
├── network
│   ├── 1-k8s-prep
│   │   └── 1-setup-env.sh
│   ├── 2-kind-env
│   │   ├── 1-setup-env.sh
│   │   ├── cni.yaml
│   │   └── flannel.yaml
│   ├── 3-clab-env
│   │   ├── 0-download.sh
│   │   ├── 1-setup-env.sh
│   │   ├── 2-setup-clab.sh
│   │   ├── 5-gc-resource.sh
│   │   ├── clab.yaml
│   │   ├── cni.yaml
│   │   ├── flannel.yaml
│   │   └── startup-confg
│   │       └── gw0.cfg
│   ├── 4-basic-netwotk
│   │   ├── 1-osi-tcpip
│   │   │   ├── 02-OSI,TCP IP.pdf
│   │   │   ├── 1-setup-env.sh
│   │   │   └── osi.md
│   │   ├── 2-ip
│   │   │   ├── 1-bridge
│   │   │   │   ├── 1-setup-clab.sh
│   │   │   │   ├── clab-bridge
│   │   │   │   │   ├── ansible-inventory.yml
│   │   │   │   │   ├── authorized_keys
│   │   │   │   │   ├── .tls
│   │   │   │   │   │   └── ca
│   │   │   │   │   │       ├── ca.key
│   │   │   │   │   │       └── ca.pem
│   │   │   │   │   └── topology-data.json
│   │   │   │   ├── clab.yaml
│   │   │   │   └── .clab.yaml.bak
│   │   │   └── 2-routing
│   │   │       ├── 1-setup-clab.sh
│   │   │       ├── clab-routing
│   │   │       │   ├── ansible-inventory.yml
│   │   │       │   ├── authorized_keys
│   │   │       │   ├── .tls
│   │   │       │   │   └── ca
│   │   │       │   │       ├── ca.key
│   │   │       │   │       └── ca.pem
│   │   │       │   └── topology-data.json
│   │   │       ├── clab.yaml
│   │   │       ├── .clab.yaml.bak
│   │   │       ├── .clab.yml.bak
│   │   │       └── startup-conf
│   │   │           └── gw0-boot.cfg
│   │   ├── 3-mac
│   │   │   ├── 1-bridge
│   │   │   │   ├── 1-setup-clab.sh
│   │   │   │   ├── clab-bridge
│   │   │   │   │   ├── ansible-inventory.yml
│   │   │   │   │   ├── authorized_keys
│   │   │   │   │   └── topology-data.json
│   │   │   │   ├── clab.yaml
│   │   │   │   └── .clab.yml.bak
│   │   │   ├── 2-routing
│   │   │   │   ├── 1-setup-clab.sh
│   │   │   │   ├── clab-routing
│   │   │   │   │   ├── ansible-inventory.yml
│   │   │   │   │   ├── authorized_keys
│   │   │   │   │   └── topology-data.json
│   │   │   │   ├── clab.yaml
│   │   │   │   ├── .clab.yml.bak
│   │   │   │   └── startup-conf
│   │   │   │       └── gw0-boot.cfg
│   │   │   └── .clab.yml.bak
│   │   └── 4-veth-pair
│   │       ├── 1-clab-veth-pair
│   │       │   ├── 1-setup-clab.sh
│   │       │   ├── clab-veth
│   │       │   │   ├── ansible-inventory.yml
│   │       │   │   ├── authorized_keys
│   │       │   │   └── topology-data.json
│   │       │   ├── clab.yaml
│   │       │   └── .clab.yml.bak
│   │       ├── 2-manual-veth-pair
│   │       │   └── 1-setup-env.sh
│   │       └── 3-manual-bridge
│   │           └── 1-setup-env.sh
│   ├── 5-demo-cni
│   │   ├── 5-host-gw
│   │   │   ├── 1-clab-host-gw
│   │   │   │   ├── 1-setup-clab.sh
│   │   │   │   ├── clab-host-gw
│   │   │   │   │   ├── ansible-inventory.yml
│   │   │   │   │   ├── authorized_keys
│   │   │   │   │   └── topology-data.json
│   │   │   │   ├── clab.yaml
│   │   │   │   ├── .clab.yml.bak
│   │   │   │   └── startup-conf
│   │   │   │       ├── gw0.cfg
│   │   │   │       └── gw1.cfg
│   │   │   └── 2-manual-host-gw
│   │   │       └── 1-setup-env.sh
│   │   ├── 6-vxlan
│   │   │   └── 1-clab-vxlan
│   │   │       ├── 1-setup-clab.sh
│   │   │       ├── clab-vxlan
│   │   │       │   ├── ansible-inventory.yml
│   │   │       │   ├── authorized_keys
│   │   │       │   └── topology-data.json
│   │   │       ├── clab.yaml
│   │   │       ├── .clab.yml.bak
│   │   │       └── startup-conf
│   │   │           ├── gw0.cfg
│   │   │           └── gw1.cfg
│   │   ├── 7-ipip
│   │   │   └── 1-clab-ipip
│   │   │       ├── 1-setup-clab.sh
│   │   │       ├── clab-ipip
│   │   │       │   ├── ansible-inventory.yml
│   │   │       │   ├── authorized_keys
│   │   │       │   └── topology-data.json
│   │   │       ├── clab.yaml
│   │   │       ├── .clab.yml.bak
│   │   │       └── startup-conf
│   │   │           ├── gw0.cfg
│   │   │           └── gw1.cfg
│   │   └── 8-gre
│   │       └── 1-clab-gre
│   │           ├── 1-setup-clab.sh
│   │           ├── clab-gre
│   │           │   ├── ansible-inventory.yml
│   │           │   ├── authorized_keys
│   │           │   └── topology-data.json
│   │           ├── clab.yaml
│   │           ├── .clab.yml.bak
│   │           └── startup-conf
│   │               ├── gw0.cfg
│   │               └── gw1.cfg
│   ├── 6-cni-backend
│   │   └── readme.md
│   └── 7-mtu
│       └── 2-routing
│           ├── 1-setup-clab.sh
│           ├── clab-mtu
│           │   ├── ansible-inventory.yml
│           │   ├── authorized_keys
│           │   ├── .tls
│           │   │   └── ca
│           │   │       ├── ca.key
│           │   │       └── ca.pem
│           │   └── topology-data.json
│           ├── clab.yaml
│           ├── .clab.yaml.bak
│           ├── .clab.yml.bak
│           └── startup-conf
│               └── gw0-boot.cfg
└── split
    ├── calico
    │   ├── 1-kind-calico-ipip
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-datapath
    │   │   │   ├── 1-proxy-arp.datapath
    │   │   │   ├── 2-ipip.datapath
    │   │   │   ├── calico-ipip.datapath
    │   │   │   ├── calico-ipip-ens160.cap
    │   │   │   ├── calico-ipip-eth0.cap
    │   │   │   └── calico-ipip-tunl0.cap
    │   │   ├── 3-reference
    │   │   │   └── 1-路由条目的意义_51CTO博客_路由条目.html
    │   │   ├── calico.yaml
    │   │   └── cni.yaml
    │   ├── 2-kind-calico-ipip-crosssubnet
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 4-datapath
    │   │   │   ├── calico-ipip.datapath
    │   │   │   ├── calico-ipip-ens160.cap
    │   │   │   ├── calico-ipip-eth0.cap
    │   │   │   └── calico-ipip-tunl0.cap
    │   │   ├── 5-gc-resource.sh
    │   │   ├── 6-reference
    │   │   │   ├── 1-路由条目的意义_51CTO博客_路由条目.html
    │   │   │   └── Overlay networking (12_5_2022 3_33_25 PM).html
    │   │   ├── calico.yaml
    │   │   ├── clab-calico-ipip-crosssubnet
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── .clab.yml.bak
    │   │   ├── cni.yaml
    │   │   └── startup-conf
    │   │       └── gw0-boot.cfg
    │   ├── 6-kind-calico-bgp-rr
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-prep-calico-bgp.sh
    │   │   ├── 4-enable-adv-service.sh
    │   │   ├── 5-datapath
    │   │   │   └── calico-bgp-rr.datapath
    │   │   ├── 6-gc-resource.sh
    │   │   ├── 7-reference
    │   │   │   ├── 1-路由条目的意义_51CTO博客_路由条目.html
    │   │   │   └── Calico BGP Topo.png
    │   │   ├── calico.yaml
    │   │   ├── clab-calico-bgp-rr
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── cni.yaml
    │   │   └── startup-conf
    │   │       ├── leaf0-boot.cfg
    │   │       ├── leaf1-boot.cfg
    │   │       ├── spine0-boot.cfg
    │   │       └── spine1-boot.cfg
    │   └── calico-vpp
    │       └── 1-setup-env.sh
    ├── cilium
    │   ├── cilium-bandwidth-manager
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-10M.yaml
    │   │   ├── 3-test-bandwidth.sh
    │   │   └── cni.yaml
    │   ├── cilium-bbr
    │   │   ├── 1-setup-env-bbr.sh
    │   │   ├── 2-setup-env-cubic.sh
    │   │   ├── BBR_vs_CUBIC.png
    │   │   ├── BBR_vs_CUBIC_rawdata.txt
    │   │   ├── cni.yaml
    │   │   └── server-23.106.143.33-5201.md
    │   ├── cilium-bgp-control-plane-features
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-install-cilium-cni.sh
    │   │   ├── 4-enable-svc-ann-feautres.sh
    │   │   ├── 5-metallb
    │   │   │   ├── 1-metallb.yaml
    │   │   │   └── 2-metallb-l2-config.yaml
    │   │   ├── a-gc-resource.sh
    │   │   ├── clab-cilium-bgp
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── .clab.yml.bak
    │   │   ├── cni.yaml
    │   │   └── startup-conf
    │   │       ├── leaf0-boot.cfg
    │   │       ├── leaf1-boot.cfg
    │   │       ├── spine0-boot.cfg
    │   │       └── spine1-boot.cfg
    │   ├── cilium-bgp-control-plane-svc-ann
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-install-cilium-cni.sh
    │   │   ├── 4-enable-svc-announcements.sh
    │   │   ├── 5-metallb
    │   │   │   ├── 1-metallb.yaml
    │   │   │   └── 2-metallb-l2-config.yaml
    │   │   ├── clab-cilium-bgp
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── .clab.yml.bak
    │   │   ├── cni.yaml
    │   │   └── startup-conf
    │   │       ├── leaf0-boot.cfg
    │   │       ├── leaf1-boot.cfg
    │   │       ├── spine0-boot.cfg
    │   │       └── spine1-boot.cfg
    │   ├── cilium-bgp-control-plane-svc-ann-lb-ipam
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-install-cilium-cni.sh
    │   │   ├── 4-enable-svc-announcements.sh
    │   │   ├── clab-cilium-bgp
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── .clab.yml.bak
    │   │   ├── cni.yaml
    │   │   └── startup-conf
    │   │       ├── leaf0-boot.cfg
    │   │       ├── leaf1-boot.cfg
    │   │       ├── spine0-boot.cfg
    │   │       └── spine1-boot.cfg
    │   ├── cilium-clustermesh
    │   │   ├── 1-setup-cilium-servicemesh-cluster1.sh
    │   │   ├── 2-setup-cilium-servicemesh-cluster2.sh
    │   │   ├── 3-enable-cilium-servicemesh.sh
    │   │   ├── 4-clustermesh-verify.sh
    │   │   ├── 5-clustermesh-service-affinity
    │   │   │   ├── 1-service-affinity.sh
    │   │   │   ├── 2-verify-service-affinity.sh
    │   │   │   ├── echoserver-service.yaml
    │   │   │   └── netshoot-ds.yaml
    │   │   ├── cluster1.yaml
    │   │   └── cluster2.yaml
    │   ├── cilium-dsr
    │   │   ├── 1-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-dsr-geneve
    │   │   ├── 1-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-dual-stack
    │   │   ├── 1-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-ebpf-hostRouting
    │   │   ├── 1-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-egress-gateway
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-test.sh
    │   │   ├── clab-cilium-egress-gateway
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── egressip.png
    │   │   └── startup-conf
    │   │       └── firewall-boot.cfg
    │   ├── cilium-envoy-ds
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-metallb
    │   │   │   ├── 1-metallb.yaml
    │   │   │   └── 2-metallb-l2-config.yaml
    │   │   ├── 3-deploy-demo-bookinfo.yaml
    │   │   ├── 4-http-gateway-rules.yaml
    │   │   └── 5-test.sh
    │   ├── cilium-gateway-api
    │   │   ├── 1-http
    │   │   │   ├── 1-setup-env.sh
    │   │   │   ├── 2-metallb
    │   │   │   │   ├── 1-metallb.yaml
    │   │   │   │   └── 2-metallb-l2-config.yaml
    │   │   │   ├── 3-deploy-demo-bookinfo.yaml
    │   │   │   ├── 4-http-gateway-rules.yaml
    │   │   │   └── 5-test.sh
    │   │   └── 2-https
    │   │       ├── 1-setup-env.sh
    │   │       ├── 2-metallb
    │   │       │   ├── 1-metallb.yaml
    │   │       │   └── 2-metallb-l2-config.yaml
    │   │       ├── 3-deploy-demo-bookinfo.yaml
    │   │       ├── 4-https-gateway-rules.yaml
    │   │       ├── 5-test.sh
    │   │       └── minica
    │   │           ├── _.cilium.rocks
    │   │           │   ├── cert.pem
    │   │           │   └── key.pem
    │   │           ├── go.mod
    │   │           ├── LICENSE.txt
    │   │           ├── main.go
    │   │           ├── minica
    │   │           ├── minica-key.pem
    │   │           ├── minica.pem
    │   │           └── README.md
    │   ├── cilium-ingress
    │   │   ├── 1-http
    │   │   │   ├── 1-setup-env.sh
    │   │   │   ├── 2-metallb
    │   │   │   │   ├── 1-metallb.yaml
    │   │   │   │   └── 2-metallb-l2-config.yaml
    │   │   │   ├── 3-ingress.yaml
    │   │   │   ├── 4-deploy-demo-bookinfo.yaml
    │   │   │   └── 5-test.sh
    │   │   └── 2-https
    │   │       ├── 1-setup-env.sh
    │   │       ├── 2-metallb
    │   │       │   ├── 1-metallb.yaml
    │   │       │   └── 2-metallb-l2-config.yaml
    │   │       ├── 3-deploy-demo-bookinfo.yaml
    │   │       ├── 4-ingress.yaml
    │   │       ├── 5-test.sh
    │   │       ├── minica
    │   │       │   ├── _.cilium.rocks
    │   │       │   │   ├── cert.pem
    │   │       │   │   └── key.pem
    │   │       │   ├── go.mod
    │   │       │   ├── LICENSE.txt
    │   │       │   ├── main.go
    │   │       │   ├── minica
    │   │       │   ├── minica-key.pem
    │   │       │   ├── minica.pem
    │   │       │   └── README.md
    │   │       └── minica.pem
    │   ├── cilium-ipsec
    │   │   ├── 1-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-ipv46-big-tcp
    │   │   ├── 1-setup-env.sh
    │   │   └── kindenv
    │   │       ├── 1-setup-env.sh
    │   │       ├── 2-test.sh
    │   │       └── netperf.yaml
    │   ├── cilium-kubeproxy
    │   │   ├── 1-direct-routing
    │   │   │   ├── 1-setup-env.sh
    │   │   │   └── cni.yaml
    │   │   └── 2-vxlan
    │   │       ├── 1-setup-env.sh
    │   │       └── cni.yaml
    │   ├── cilium-kubeproxy-replacement
    │   │   ├── 1-direct-routing
    │   │   │   ├── 1-setup-env.sh
    │   │   │   └── cni.yaml
    │   │   └── 2-vxlan
    │   │       ├── 1-setup-env.sh
    │   │       └── cni.yaml
    │   ├── cilium-kubeproxy-replacement-ebpf
    │   │   ├── 1-direct-routing
    │   │   │   ├── 1-setup-env.sh
    │   │   │   └── cni.yaml
    │   │   └── 2-vxlan
    │   │       ├── 1-setup-env.sh
    │   │       └── cni.yaml
    │   ├── cilium-l2-aware-lb
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-cilium-l2annpolicy.sh
    │   │   ├── .clab.yaml.bak
    │   │   ├── .clab.yml.bak
    │   │   ├── cni.yaml
    │   │   └── datapath_client-lb_ip-node_ip.cap
    │   ├── cilium-l2-aware-pod-ann
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-cilium-l2annpolicy.sh
    │   │   ├── 4-test.md
    │   │   ├── clab-cilium-l2-aware-lb-pod-ann
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── cni.yaml
    │   │   └── vm
    │   │       └── 1-setup-env.sh
    │   ├── cilium-l2-aware-with-lb-ipam
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-cilium-l2annpolicy.sh
    │   │   ├── clab-cilium-l2-aware-lb-ipam
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── .clab.yml.bak
    │   │   ├── cni.yaml
    │   │   └── startup-conf
    │   │       └── gw0-boot.cfg
    │   ├── cilium-l7-aware-traffic-management
    │   ├── cilium-lb-ipam
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-mutual-auth
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-mutual-auth-prep.sh
    │   │   ├── 3-test.sh
    │   │   └── mutual-auth
    │   │       ├── echoserver1.yaml
    │   │       ├── echoserver2.yaml
    │   │       ├── nginx-conf-map.yaml
    │   │       ├── nginx-zone.yaml
    │   │       ├── ns.yaml
    │   │       ├── siege.yaml
    │   │       └── zone_svc.yaml
    │   ├── cilium-socket-lb
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-wireguard
    │   │   ├── 1-setup-env.sh
    │   │   └── cni.yaml
    │   ├── cilium-wireguard-nodeEncryption
    │   │   ├── 1-setup-env.sh
    │   │   └── cni.yaml
    │   └── multipass
    │       ├── ubuntu2204
    │       │   ├── 1-setup-env.sh
    │       │   └── cni.yaml
    │       ├── ubuntu2304
    │       │   ├── 1-setup-env.sh
    │       │   └── cni.yaml
    │       ├── ubuntu2304-kernel6.4
    │       │   ├── 1-setup-env.sh
    │       │   └── cni.yaml
    │       └── vm-ubuntu22.04
    │           └── 1-setup-env.sh
    ├── flannel
    │   └── flannel
    ├── istio
    │   └── istio-install
    │       ├── 1-setup-env.sh
    │       └── cni.yaml
    ├── k8senv
    │   ├── bashrc
    │   ├── k3s
    │   │   ├── 1-kpr-setup-env.sh
    │   │   ├── 2-nokpr-setup-env.sh
    │   │   ├── calico.yaml
    │   │   ├── cilium-kpr.sh
    │   │   ├── cilium-nokpr.sh
    │   │   ├── cni.yaml
    │   │   ├── flannel.yaml
    │   │   └── storageclass-local-pv
    │   │       ├── localpv-sc-storageClass.yaml
    │   │       ├── local-pv.sh
    │   │       └── provisioner-local-pv.yaml
    │   ├── metallb
    │   │   ├── 1-metallb.yaml
    │   │   └── 2-metallb-l2-config.yaml
    │   ├── notes
    │   ├── openshift
    │   │   └── nokpr-setup-env.sh
    │   └── vmenv
    │       ├── 1-setup-env.sh
    │       ├── 2-setup-env.sh
    │       └── kindenv
    │           ├── 1-setup-env.sh
    │           ├── 2-test.sh
    │           └── netperf.yaml
    ├── multus
    │   ├── 1-kind-multus-macvlan
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-macvlan-testpods.sh
    │   │   ├── 4-gc-resource.sh
    │   │   └── k8snetworkplumbingwg
    │   │       ├── calico.yaml
    │   │       ├── daemonset-install.yaml
    │   │       ├── multus-daemonset.yml
    │   │       ├── whereabouts.cni.cncf.io_ippools.yaml
    │   │       └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
    │   ├── 2-kind-multus-macvlan-sbr
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-setup-clab.sh
    │   │   ├── 3-macvlan-sbr-testpods.sh
    │   │   ├── 4-test-macvlan-with-sbr.sh
    │   │   ├── 6-reference
    │   │   │   └── Microk8s - Multus Networking – ZenCoffee Blog – random notes, guides, and thoughts… (12_14_2022 11_25_53 AM).html
    │   │   ├── clab-cni-multus
    │   │   │   ├── ansible-inventory.yml
    │   │   │   ├── authorized_keys
    │   │   │   ├── .tls
    │   │   │   │   └── ca
    │   │   │   │       ├── ca.key
    │   │   │   │       └── ca.pem
    │   │   │   └── topology-data.json
    │   │   ├── clab.yaml
    │   │   ├── .clab.yaml.bak
    │   │   ├── .clab.yml.bak
    │   │   ├── k8snetworkplumbingwg
    │   │   │   ├── calico.yaml
    │   │   │   ├── daemonset-install.yaml
    │   │   │   ├── multus-daemonset.yml
    │   │   │   ├── whereabouts.cni.cncf.io_ippools.yaml
    │   │   │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
    │   │   └── startup-conf
    │   │       ├── gw0-boot.cfg
    │   │       └── gw0.cfg
    │   ├── 3-kind-multus-ipvlanl2
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-ipvlan-testpods.sh
    │   │   ├── 3-test-ipvlanl2.sh
    │   │   ├── 5-gc-resource.sh
    │   │   └── k8snetworkplumbingwg
    │   │       ├── calico.yaml
    │   │       ├── daemonset-install.yaml
    │   │       ├── multus-daemonset.yml
    │   │       ├── whereabouts.cni.cncf.io_ippools.yaml
    │   │       └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
    │   ├── 4-kind-multus-ipvlanl2-sbr
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-ipvlan-with-sbr-testpods.sh
    │   │   ├── 3-test-ipvlan-with-sbr.sh
    │   │   ├── 4-same-L2-SBR-priority.sh
    │   │   ├── 5-same-L2-both-SBR-priority.sh
    │   │   ├── 7-reference
    │   │   │   └── Microk8s - Multus Networking – ZenCoffee Blog – random notes, guides, and thoughts… (12_14_2022 11_25_53 AM).html
    │   │   ├── k8snetworkplumbingwg
    │   │   │   ├── calico.yaml
    │   │   │   ├── daemonset-install.yaml
    │   │   │   ├── multus-daemonset.yml
    │   │   │   ├── whereabouts.cni.cncf.io_ippools.yaml
    │   │   │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
    │   │   └── x-cetnos.sh
    │   ├── 5-kind-multus-ipvlanl3
    │   │   ├── 1-setup-env.sh
    │   │   ├── 2-ipvlan-testpods.sh
    │   │   ├── 3-test-ipvlanl3.sh
    │   │   ├── 5-gc-resource.sh
    │   │   ├── 6-reference
    │   │   │   └── ipvlan-l3.sh
    │   │   └── k8snetworkplumbingwg
    │   │       ├── calico.yaml
    │   │       ├── daemonset-install.yaml
    │   │       ├── multus-daemonset.yml
    │   │       ├── whereabouts.cni.cncf.io_ippools.yaml
    │   │       └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
    │   ├── 6-multus-sriov-kernel
    │   │   ├── Enable-SRIOV-Kernel.html
    │   │   └── How-to-enable-SRIOV-Kernel.YAML
    │   ├── 7-multus-sriov-dpdk-vpp
    │   │   ├── Enable-SRIOV-DPDK-VPP.html
    │   │   └── How-to-enable-SRIOV-DPDK-VPP.YAML
    │   ├── 8-multus-af-xdp
    │   │   ├── Daemonset
    │   │   │   ├── DMScdq.yaml
    │   │   │   └── DMSprimary.yaml
    │   │   ├── NAD
    │   │   │   └── EastWest.yaml
    │   │   └── POD
    │   │       ├── afxdp-podspec.yaml
    │   │       └── l2fwd-1NIC.yaml
    │   └── 9-multus-host-device
    │       ├── 1-setup-env.sh
    │       ├── 2-setup-clab.sh
    │       ├── 3-deploy-demo.sh
    │       ├── clab-cni-multus
    │       │   ├── ansible-inventory.yml
    │       │   ├── authorized_keys
    │       │   ├── .tls
    │       │   │   └── ca
    │       │   │       ├── ca.key
    │       │   │       └── ca.pem
    │       │   └── topology-data.json
    │       ├── clab.yaml
    │       ├── .clab.yaml.bak
    │       ├── k8snetworkplumbingwg
    │       │   ├── calico.yaml
    │       │   ├── daemonset-install.yaml
    │       │   ├── multus-daemonset.yml
    │       │   ├── whereabouts.cni.cncf.io_ippools.yaml
    │       │   └── whereabouts.cni.cncf.io_overlappingrangeipreservations.yaml
    │       └── startup-conf
    │           ├── gw0-boot.cfg
    │           └── gw0.cfg
    ├── tcpenv
    │   └── tcp_retries1-tcp_retries2
    │       └── tcp_retry_prameter.md
    └── vppenv
        ├── 1-setup-env.md
        ├── calico.yaml
        └── instll-kvm-utils

849 directories, 2470 files
