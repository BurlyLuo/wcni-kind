# LabasCode

<div align="center">

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.27+-blue.svg)](https://kubernetes.io/)
[![CNI](https://img.shields.io/badge/CNI-Supported-green.svg)](https://www.cni.dev/)
[![Cloud Native](https://img.shields.io/badge/Cloud_Native-Ready-orange.svg)](https://cncf.io/)

**A Comprehensive Laboratory for Cloud-Native Networking, Service Mesh, and Distributed Systems**

</div>

## 🚀 Overview

LabasCode is an advanced, comprehensive laboratory environment for exploring and testing cutting-edge cloud-native technologies, with a particular focus on:

- **Container Network Interface (CNI)** implementations and configurations
- **Service Mesh** architectures and integrations
- **Multi-cluster** networking and connectivity
- **AI/ML Networking** for high-performance computing
- **eBPF** powered observability and security
- **Advanced Networking** protocols and topologies

This repository contains extensive configurations, deployment scripts, and testing environments for various cloud-native networking solutions.

## 📁 Directory Structure

### 🤖 AI/ML Networking (`aiProd`)
- **AI Pod Networking**: Advanced architectures for AI workloads
  - Spine-Leaf topologies
  - CLOS (Close-Looped Optical System) designs
  - ECMP (Equal Cost Multi-Path) routing
  - InfiniBand RDMA configurations
- **RDMA Setup**: Remote Direct Memory Access configurations for high-performance computing

### 🌐 CNI Implementations

#### Antrea (`antrea/`)
- **VXLAN Mode**: Encapsulation-based overlay networking
- **Geneve Mode**: Generic Network Virtualization Encapsulation
- **GRE Mode**: Generic Route Encapsulation
- **WireGuard Mode**: Encrypted overlay networking
- **IPSec Mode**: Secure tunneling protocols
- **NoEncap Mode**: Direct routing without encapsulation
- **STT Mode**: Stateless Transport Tunneling

#### Cilium (`cilium/`)
- **Multiple Versions**: Various Cilium releases for compatibility testing
- **BGP Control Plane**: Border Gateway Protocol integration
- **eBPF Data Path**: High-performance kernel-level networking
- **Multi-cluster Networking**: Cross-cluster connectivity
- **Service Mesh Integration**: Istio and Envoy integration
- **L2 Announcements**: Layer 2 load balancing
- **IPSec/WireGuard**: Encrypted inter-node communication
- **Dual Stack**: IPv4/IPv6 dual-stack support
- **Host Firewall**: Kernel-level host-based firewall
- **Hubble**: Network, service & security observability
- **KubeProxy Replacement**: Full replacement for kube-proxy functionality
- **Performance & Scalability**: Advanced performance testing and optimization
- **Network Security**: Comprehensive network policy implementations
- **External Networking**: Integration with external networks and services
- **Service Mesh**: Advanced service mesh capabilities with Envoy integration
- **L2 Announcements**: Layer 2 announcements for LoadBalancer services
- **SCTP Support**: Stream Control Transmission Protocol support

#### Calico (`calico/`)
- **Multiple Versions**: Various Calico releases for compatibility testing
- **IPIP Mode**: IP-in-IP tunneling
- **VXLAN Mode**: Overlay networking
- **BGP Configuration**: Border Gateway Protocol routing
- **eBPF Mode**: High-performance data plane
- **Full Mesh**: Full mesh network topology
- **BGP Route Reflection**: Route reflection for scalability
- **Dual Stack**: IPv4/IPv6 dual-stack support
- **Multus Integration**: Integration with Multus CNI
- **Cluster IP**: Cluster IP service implementations
- **NodePort**: NodePort service implementations
- **LoadBalancer**: LoadBalancer service implementations
- **IPVS**: IP Virtual Server integration

#### Flannel (`flannel/`)
- **UDP Mode**: User Datagram Protocol encapsulation
- **VXLAN Mode**: Virtual eXtensible Local Area Network
- **Host-GW Mode**: Host Gateway routing
- **IPIP Mode**: IP-in-IP tunneling
- **WireGuard Mode**: Encrypted overlay
- **IPSec**: IP Security protocol implementations
- **Direct Routing**: Native routing without encapsulation
- **Cross-Subnet**: Cross-subnet communication optimizations

#### OVN Kubernetes (`ovnkube/`)
- **OVN Integration**: Open Virtual Network implementation
- **Logical Switches**: Virtual network segmentation
- **Logical Routers**: Distributed routing
- **Load Balancers**: Built-in service discovery

### 🕸️ Service Mesh (`istio/`, `ztunnel/`)
- **Istio Ambient**: Zero-trust networking with ambient mesh
- **Ztunnel**: Lightweight security proxy
- **Service Discovery**: Automatic service registration
- **Traffic Management**: Request routing and load balancing
- **Security**: mTLS, authorization, and authentication

### 🌍 Multi-Cluster (`mcluster/`)
- **Cilium Clustermesh**: Cross-cluster connectivity
- **Linkerd Clustermesh**: Service mesh federation
- **Skupper Clustermesh**: Hybrid cloud connectivity
- **Submariner Clustermesh**: Multi-cluster networking
- **Liqo**: Virtual cluster interconnection

### 🌐 Multi-Networking (`multus/`)
- **MACVLAN**: Multiple network interfaces per pod
- **IPVLAN**: Layer 2/3 virtual interfaces
- **SR-IOV**: Single Root I/O Virtualization
- **DPDK**: Data Plane Development Kit integration
- **VPP**: Vector Packet Processing
- **Static IPAM**: Static IP address management
- **Feature Gates**: Advanced feature configurations
- **Security Context**: Pod security context configurations
- **CGroup v2**: Control group version 2 support
- **Redis Integration**: Redis database networking
- **Netdata Monitoring**: Network monitoring integration
- **Flux CD Integration**: GitOps continuous delivery
- **Nexus GitLab**: CI/CD pipeline integration
- **VLAN Tagging**: Virtual LAN tagging support

### 🔧 Infrastructure (`k8senv/`, `netenv/`)
- **Kind Environments**: Kubernetes in Docker clusters
- **VM Environments**: Virtual machine-based deployments
- **ContainerLab**: Network emulation and testing
- **Network Preparation**: Infrastructure setup scripts
- **Environment Components**: Various infrastructure components
- **K3s Integration**: Lightweight Kubernetes integration
- **KubeVirt**: Virtual machine management
- **MetalLB**: Load balancer for bare metal clusters
- **OpenShift**: Red Hat OpenShift integration

### 🔒 Security & Observability (`tetragon/`, `kernel/`)
- **Tetragon**: eBPF-based security and observability
- **Kernel Configurations**: Low-level system tuning
- **iptables Tracing**: Network filtering and monitoring
- **TLS Decryption**: Encrypted traffic inspection
- **Certificate Manager**: Certificate management integration
- **Self-Signed Certificates**: Internal certificate generation
- **TCP Retries**: TCP connection retry configurations

### 🌐 Network Operating Systems (`sonic/`)
- **AsterOS**: Alternative network operating system
- **SONiC**: Software for Open Networking in the Cloud
- **VyOS**: Network operating system based on Debian GNU/Linux
- **FRRouting**: Free Range Routing
- **Huawei**: Huawei network equipment integration
- **Arista**: Arista network equipment integration
- **Broadcom**: Broadcom switch ASIC integration
- **HPC Networking**: High-performance computing network configurations
- **ContainerLab Integration**: Network emulation with containerlab

### 🌐 Advanced Networking (`netenv/`, `svcflow/`, `kernel/`)
- **Network Environment Preparation**: Infrastructure setup
- **Advanced Networking Configurations**: Complex network setups
- **Service Flow Analysis**: Service connectivity and flow analysis
- **Connection Tracking**: Netfilter connection tracking
- **SocketLB**: Socket-based load balancing
- **Kernel Tuning**: Advanced kernel parameter tuning
- **CPU Quotas**: CPU resource management
- **TCP Retries**: TCP connection retry configurations
- **TLS Decryption**: Encrypted traffic inspection
- **Nginx L7/L4**: Layer 7 and Layer 4 load balancing
- **Self-Signed Certificates**: Internal certificate generation
- **RDMA**: Remote Direct Memory Access configurations
- **BGP**: Border Gateway Protocol implementations
- **ECMP**: Equal Cost Multi-Path routing
- **DSR**: Direct Server Return for load balancing
- **Maglev Hashing**: Consistent hashing for load balancing
- **XDP Acceleration**: eXpress Data Path acceleration
- **Socket Load Balancer**: Kernel-level socket-based load balancing
- **DSR (Direct Server Return)**: High-performance load balancing mode
- **XDP Acceleration**: Hardware-accelerated packet processing
- **Host Port Support**: Container host port mapping
- **Graceful Termination**: Proper pod termination handling
- **Endpoint CRD**: Cilium endpoint custom resource definitions
- **CiliumEndpointSlice**: Enhanced endpoint management
- **Bandwidth Manager**: Network bandwidth management
- **BBR Congestion Control**: BBR congestion control algorithm

### 🌐 Extended Kubernetes (`ekubernetes/`)
- **Kind Environment**: Kubernetes in Docker setup
- **MetalLB**: Load balancer for bare metal
- **Ingress**: Ingress controller configurations
- **Certificate Manager**: Certificate management
- **Nginx L7/L4**: Layer 7 and Layer 4 load balancing
- **Self-Signed Certificates**: Internal certificate generation
- **Shared Memory**: Shared memory configurations
- **Pod Termination**: Pod termination logic
- **Prometheus/Grafana**: Monitoring and visualization
- **Worker Node Debug**: Worker node debugging
- **Feature Enablement**: Kubernetes feature enablement
- **Dedicated CPU**: CPU isolation configurations
- **Harbor**: Harbor registry integration

## 🛠️ Key Features

### Advanced Networking Protocols
- **RDMA**: Remote Direct Memory Access for HPC
- **BGP**: Border Gateway Protocol for external connectivity
- **ECMP**: Equal Cost Multi-Path routing
- **DSR**: Direct Server Return for load balancing
- **Maglev Hashing**: Consistent hashing for load balancing
- **XDP Acceleration**: eXpress Data Path acceleration
- **Socket Load Balancer**: Kernel-level socket-based load balancing
- **DSR (Direct Server Return)**: High-performance load balancing mode
- **XDP Acceleration**: Hardware-accelerated packet processing
- **Host Port Support**: Container host port mapping
- **Graceful Termination**: Proper pod termination handling
- **Endpoint CRD**: Cilium endpoint custom resource definitions
- **CiliumEndpointSlice**: Enhanced endpoint management
- **Bandwidth Manager**: Network bandwidth management
- **BBR Congestion Control**: BBR congestion control algorithm

### High-Performance Data Paths
- **eBPF**: Extended Berkeley Packet Filter programs
- **XDP**: eXpress Data Path for ultra-low latency
- **DPDK**: Data Plane Development Kit
- **VPP**: Vector Packet Processing
- **Kernel Bypass**: Direct hardware access
- **SR-IOV**: Single Root I/O Virtualization
- **DPDK Integration**: Data plane development kit integration
- **VPP Integration**: Vector packet processing integration
- **Hardware Offload**: Network hardware acceleration

### Service Mesh Capabilities
- **Ambient Mesh**: Zero-trust networking without sidecars
- **L7 Traffic Management**: Application-layer routing
- **Security Policies**: Fine-grained access controls
- **Observability**: Distributed tracing and metrics
- **Gateway API Support**: Standardized API gateway configuration
- **Mutual Authentication**: mTLS-based authentication
- **TLS Decryption**: Encrypted traffic inspection
- **DNS-based Policies**: Domain name system-based policies
- **L7 Visibility**: Layer 7 traffic visibility
- **Traffic Splitting**: Advanced traffic routing

### Multi-Cluster Operations
- **Clustermesh**: Cross-cluster service discovery
- **Federated Policies**: Consistent security across clusters
- **Global Load Balancing**: Multi-region traffic routing
- **Disaster Recovery**: Cross-cluster failover
- **Service Affinity**: Cross-cluster service affinity
- **Cluster Mesh Verification**: Multi-cluster connectivity validation

### Network Security & Policy
- **Network Policy**: Kubernetes network policy implementation
- **Cluster Network Policy**: Cluster-wide network policy
- **L3/L4 Policy**: Layer 3 and Layer 4 network policies
- **L7 Policy**: Layer 7 application layer policies
- **DNS-based Policy**: Domain name system-based policies
- **FQDN Policy**: Fully qualified domain name policies
- **Endpoint-based Policy**: Endpoint-specific policies
- **Identity-based Policy**: Identity-aware network policies

## 📊 Technology Stack

| Technology | Purpose | Key Features |
|------------|---------|--------------|
| **Kubernetes** | Container Orchestration | v1.27+, Custom Resources |
| **CNI Plugins** | Network Connectivity | Cilium, Calico, Flannel, Antrea |
| **Service Mesh** | Traffic Management | Istio Ambient, Ztunnel |
| **eBPF** | Observability & Security | Tetragon, Hubble, Traceflow |
| **BGP** | External Connectivity | Cilium BGP Control Plane |
| **RDMA** | High-Performance Networking | InfiniBand, RoCE |
| **Multi-Cluster** | Federation | Clustermesh, Submariner |
| **Network OS** | Switch Management | SONiC, VyOS, FRR, AsterOS |

## 🚀 Quick Start

### Prerequisites
```bash
# Required tools
- Docker v20+
- Kind v0.20+
- kubectl v1.27+
- Helm v3+
- ContainerLab v0.59+
- Multipass (for VM environments)
```

### Deploy Cilium with BGP
```bash
cd aiProd/1-AIPod/6-PoD
./1-setup-env.sh
./2-setup-clab.sh
./3-install-cilium.sh
./4-enable-bgp-peer.sh
```

### Deploy Multi-Cluster Environment
```bash
cd mcluster/1-mcluster-cilium-clustermesh
./1-setup-cilium-servicemesh-cluster1.sh
./2-setup-cilium-servicemesh-cluster2.sh
./3-enable-cilium-servicemesh.sh
./4-clustermesh-verify.sh
```

## 📈 Advanced Use Cases

### AI/ML Workload Optimization
- **Spine-Leaf Topologies**: Optimized for east-west traffic
- **RDMA Support**: Ultra-low latency for HPC workloads
- **CLOS Architecture**: Scalable fabric design
- **ECMP Load Balancing**: Efficient traffic distribution

### Network Operating Systems Integration
- **SONiC**: Software for Open Networking in the Cloud
- **VyOS**: Network operating system for routing and firewalling
- **FRRouting**: Free Range Routing for BGP and OSPF
- **AsterOS**: Alternative network operating system
- **ContainerLab Integration**: Network emulation with real network OSes

### Service Mesh Evolution
- **Ambient Mesh**: Zero-trust without sidecar overhead
- **L7 Security**: Application-layer policy enforcement
- **Traffic Splitting**: A/B testing and canary deployments
- **Gateway APIs**: Standardized API gateway configuration

### Multi-Cloud Networking
- **Hybrid Connectivity**: On-premises to cloud integration
- **Cross-Cloud Federation**: Multi-provider service mesh
- **Global Load Balancing**: Intelligent traffic routing
- **Disaster Recovery**: Automated failover mechanisms

## 🧪 Testing & Validation

### Network Policy Testing
```bash
# Test L3/L4 policies
kubectl apply -f network-policy-examples/

# Test L7 policies
kubectl apply -f l7-policy-examples/

# Validate connectivity
kubectl exec -it pod-name -- ping other-pod
```

### Performance Benchmarking
```bash
# Bandwidth testing
kubectl apply -f bandwidth-test.yaml

# Latency testing
kubectl apply -f latency-test.yaml

# Throughput validation
kubectl apply -f throughput-test.yaml
```

## 📚 Documentation & Resources

### Official References
- [Cilium Documentation](https://docs.cilium.io/)
- [Istio Documentation](https://istio.io/latest/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [eBPF Documentation](https://ebpf.io/)
- [SONiC Documentation](https://github.com/sonic-net/SONiC)
- [VyOS Documentation](https://docs.vyos.io/)

### Community Resources
- [CNCF Projects](https://www.cncf.io/projects/)
- [Kubernetes Slack](https://slack.k8s.io/)
- [Cilium Slack](https://cilium.herokuapp.com/)
- [SONiC Community](https://sonic-net.github.io/SONiC)

## 🤝 Contributing

We welcome contributions to LabasCode! Please see our [Contributing Guide](CONTRIBUTING.md) for details on:

- Submitting pull requests
- Reporting issues
- Adding new CNI configurations
- Improving documentation
- Expanding test cases

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Wei Luo** - Initial work and ongoing maintenance
- Contact: olaf.luo@foxmail.com
- Documentation: https://www.yuque.com/wei.luo

## 🙏 Acknowledgments

- The Kubernetes community for the foundational container orchestration platform
- The CNI community for standardized network interfaces
- The Cilium team for advanced eBPF-based networking
- The Istio team for service mesh innovation
- The SONiC community for open networking solutions
- All contributors to the cloud-native ecosystem

---

<div align="center">

**LabasCode** - *Advanced Cloud-Native Infrastructure Laboratory*

🚀 *Exploring the Future of Cloud-Native Networking*

</div>
