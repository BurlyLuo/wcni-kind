# FRR VXLAN BGP EVPN Distributed-Gateway

<div align="center">

```mermaid
graph TB
    %% Nodes list
    spine1["spine1<br/>eth1:1.1.1.10/24"]
    leaf1_vrf["leaf1<br/>vrf-evpn"]

    subgraph "<font color='red'>L2/L3 GW Layer</font>"
        subgraph "leaf1-eth1:1.1.1.11/24"
            subgraph "bridge br10"
                subgraph "interface: eth2 and vxlan10"
                    leaf1-br10["br10<br/>br10:10.1.5.254/24"]
                end
            end
            subgraph "bridge br100"
                subgraph "interface: vxlan100"
                    leaf1-br100["br100"]
                end
            end    
        end
    end
    leaf2_vrf["leaf2<br/>vrf-evpn"]

    subgraph "<font color='red'>L2/L3 GW Layer</font>"
        subgraph "leaf2-eth1:1.1.1.12/24"
            subgraph "bridge br10"
                subgraph "interface: eth2 and vxlan10"
                    leaf2-br10["br10<br/>br10:10.1.5.254/24"]
                end
            end
            subgraph "bridge br20"
                subgraph "interface: eth3"
                    leaf2-br20["br20<br/>br20:10.1.8.254/24"]
                end
            end
            subgraph "bridge br100"
                subgraph "interface: vxlan100"
                    leaf2-br100["br100"]
                end
            end    
        end
    end

    vm1["vm1<br/>10.1.5.10/24<br/>GW:10.1.5.254/24"]
    vm2["vm2<br/>10.1.8.10/24<br/>GW:10.1.8.254/24"]
    vm3["vm3<br/>10.1.5.11/24<br/>GW:10.1.5.254/24"]
    
    %% links
    spine1 --- leaf1_vrf
    leaf1_vrf -.- leaf1-br10
    leaf1_vrf -.- leaf1-br100

    spine1 --- leaf2_vrf
    leaf2_vrf -.- leaf2-br10
    leaf2_vrf -.- leaf2-br20
    leaf2_vrf -.- leaf2-br100

    leaf1-br10 --- vm1
    leaf2-br10 --- vm3
    leaf2-br20 --- vm2


    linkStyle 0 stroke:#ff6b6b,stroke-width:3px,color:#ff6b6b
    linkStyle 1 stroke:#ff6b6b,stroke-width:3px,color:#ff6b6b
    linkStyle 2 stroke:#ff6b6b,stroke-width:3px,color:#ff6b6b
    linkStyle 3 stroke:#ff6b6b,stroke-width:3px,color:#ff6b6b
    linkStyle 4 stroke:#ff6b6b,stroke-width:3px,color:#ff6b6b
    linkStyle 5 stroke:#ff6b6b,stroke-width:3px,color:#ff6b6b
    linkStyle 6 stroke:#ff6b6b,stroke-width:3px,color:#ff6b6b

```
</div>




```shell
入包 → br10 → vlan10 (SVI) → evpn-vrf → 路由表
    ↓ 查找 10.1.8.0/24 路由
    ↓ 路由指向 br100（因为 br100 在 VRF 中）###[B>* 10.1.8.0/24 [20/0] via 1.1.1.12, br100 onlink, weight 1, 00:01:24]
    ↓ br100 查找 MAC 表，从 vxlan100 发出
    ↓ 封装 VNI=100
leaf1# show ip route vrf evpn-vrf 
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

IPv4 unicast VRF evpn-vrf:
C>* 10.1.5.0/24 is directly connected, br10, weight 1, 00:01:24
L * 10.1.5.254/32 is directly connected, br10, weight 1, 00:01:24
L>* 10.1.5.254/32 is directly connected, br10, weight 1, 00:01:24
B>* 10.1.8.0/24 [20/0] via 1.1.1.12, br100 onlink, weight 1, 00:01:24
leaf1# 
```