# WCNI-Kind: Cloud Native Networking Labs ☁️ 🚀

![License](https://img.shields.io/github/license/BurlyLuo/wcni-kind?style=flat-square) ![Stars](https://img.shields.io/github/stars/BurlyLuo/wcni-kind?style=flat-square) ![Issues](https://img.shields.io/github/issues/BurlyLuo/wcni-kind?style=flat-square)

**WCNI-Kind** is a comprehensive **"Lab as Code"** (LabasCode) environment designed to bridge the gap between simulated Kubernetes clusters and real-world physical networking. 

By combining **Kind** (Kubernetes in Docker) with **Containerlab**, this project allows you to spin up complex, multi-node Kubernetes clusters connected to realistic underlay networks (simulated via FRR, Arista, or Linux routers) directly on your local machine.

> **Target Audience:** Network Engineers, SREs, and CNI Developers looking to deep-dive into K8s networking (Calico, Cilium, Kube-OVN) without needing a hardware lab.

---

## 🌟 Core Philosophy: LabasCode

The heart of this project is the **`LabasCode`** directory. Every lab is defined as code—infrastructure, network topology, and CNI configuration—ensuring 100% reproducibility.

Instead of manually configuring routers and clusters, you execute a standardized workflow:
1.  **Define** the topology (YAML).
2.  **Bootstrap** the environment (Scripts).
3.  **Validate** the datapath.

---

## 🏗️ Architecture

Unlike a standard Kind cluster which runs on a flat Docker network, **WCNI-Kind** introduces a "Physical" Underlay layer using **Containerlab**.

```mermaid
graph TD
    subgraph Host_Machine [Local Machine / VM]
        subgraph Control_Plane [Orchestration]
            Script[setup-env.sh]
            CLAB[Containerlab]
        end
        
        subgraph Underlay_Network [Simulated Fabric]
            TOR1[ToR Switch 1 (FRR/VyOS)]
            TOR2[ToR Switch 2 (FRR/VyOS)]
            Spine[Spine Router]
        end
        
        subgraph Overlay_Cluster [Kind Cluster]
            CP[K8s Control Plane]
            Worker1[Worker Node 1]
            Worker2[Worker Node 2]
        end
        
        %% Connections
        Script -->|Provisions| CP
        CLAB -->|Manages| TOR1
        CLAB -->|Manages| TOR2
        
        Worker1 <==>|Eth1| TOR1
        Worker2 <==>|Eth1| TOR2
        TOR1 <==>|BGP| Spine
        TOR2 <==>|BGP| Spine
    end
    
    style Host_Machine fill:#f9f9f9,stroke:#333,stroke-width:2px
    style Underlay_Network fill:#e1f5fe,stroke:#01579b
    style Overlay_Cluster fill:#e8f5e9,stroke:#2e7d32