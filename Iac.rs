.
├── allk8s
│   ├── 0-Docs
│   │   ├── aliyun-k8s.tgz
│   │   ├── Docker容器你需要知道的 - Mr.Ye Blog (12_16_2022 9_04_16 PM).html
│   │   └── 【译】Docker 和子进程“僵尸化”问题 (12_16_2022 9_23_53 PM).html
│   ├── 1-Docker-env
│   │   └── 1-userguide.sh
│   ├── multipass
│   │   ├── calico.yaml
│   │   ├── install-k3s-cluster.sh
│   │   ├── k3s-master0.config.yaml
│   │   ├── k3s-worker1.config.yaml
│   │   └── k3s-worker2.config.yaml
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
│   │   │   └── topology-data.json
│   │   ├── clab.yaml
│   │   ├── .clab.yml.bak
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
│   ├── config
│   ├── description
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
│   │               └── HEAD
│   ├── objects
│   │   ├── info
│   │   └── pack
│   │       ├── pack-fb27517cf92ce3b04e486c044b3d5031bab09652.idx
│   │       └── pack-fb27517cf92ce3b04e486c044b3d5031bab09652.pack
│   ├── packed-refs
│   └── refs
│       ├── heads
│       │   └── master
│       ├── remotes
│       │   └── origin
│       │       └── HEAD
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
│   │   │   │   │   └── topology-data.json
│   │   │   │   └── clab.yaml
│   │   │   └── 2-routing
│   │   │       ├── 1-setup-clab.sh
│   │   │       ├── clab-routing
│   │   │       │   ├── ansible-inventory.yml
│   │   │       │   ├── authorized_keys
│   │   │       │   └── topology-data.json
│   │   │       ├── clab.yaml
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
│   └── 6-cni-backend
│       └── readme.md
├── split
│   ├── calico
│   │   └── calico
│   ├── cilium
│   │   ├── cilium-kubeproxy
│   │   │   ├── 1-direct-routing
│   │   │   │   ├── 1-setup-env.sh
│   │   │   │   └── cni.yaml
│   │   │   └── 2-vxlan
│   │   │       ├── 1-setup-env.sh
│   │   │       └── cni.yaml
│   │   ├── cilium-kubeproxy-replacement
│   │   │   ├── 1-direct-routing
│   │   │   │   ├── 1-setup-env.sh
│   │   │   │   └── cni.yaml
│   │   │   └── 2-vxlan
│   │   │       ├── 1-setup-env.sh
│   │   │       └── cni.yaml
│   │   └── cilium-kubeproxy-replacement-ebpf
│   │       ├── 1-direct-routing
│   │       │   ├── 1-setup-env.sh
│   │       │   └── cni.yaml
│   │       └── 2-vxlan
│   │           ├── 1-setup-env.sh
│   │           └── cni.yaml
│   ├── flannel
│   │   └── flannel
│   ├── istio
│   │   └── istio
│   └── multus
│       └── multus
└── tree.txt

460 directories, 1252 files
