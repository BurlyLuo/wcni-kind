# SONiC BGP EVPN VxLAN

<div align="center">

```mermaid
%%{init: {'theme': 'default', 'flowchart': {'padding': 2, 'rankSpacing': 35}}}%%
graph TB
    %% Nodes list
    subgraph "Spine Layer"
        S1["spine1<br/>Lo:1.1.1.1/32<br/> AS 500"]
        S2["spine2<br/>Lo:2.2.2.2/32<br/> AS 800"]
    end
    
    subgraph "leaf1:vtep_wluo:5.5.5.5/32↔leaf2:vtep_wluo:8.8.8.8/32<br/><br/><br/>Leaf Layer"
        L1["leaf1<br/>Lo:5.5.5.5/32<br/> AS 65005"]
        L2["leaf2<br/>Lo:8.8.8.8/32<br/> AS 65008"]
    end
    


    subgraph "Server Layer"
        BR1["NIC"]
        BR2["NIC"]
        H1["vm1<br/>vlan5<br/>10.1.5.10/24"]
        H2["vm2<br/>vlan8<br/>10.1.8.10/24"]
        H3["vm3<br/>vlan5<br/>10.1.5.11/24"]
        H4["vm4<br/>vlan8<br/>10.1.8.11/24"]
    end

    %% Underlay links
    S1 --- |"spine1:eth1:10.1.10.2/24<br/>↔<br/>leaf1:eth1:10.1.10.1/24"| L1
    S1 --- |"spine1:eth2:10.1.34.2/24<br/>↔<br/>leaf2:eth1:10.1.34.1/24"| L2
    S2 --- |"spine2:eth1:10.1.12.2/24<br/>↔<br/>leaf1:eth2:10.1.12.1/24"| L1
    S2 --- |"spine2:eth2:10.1.11.2/24<br/>↔<br/>leaf2:eth2:10.1.11.1/24"| L2
    
    %% Leaf to Access Switch
    L1 --- |"leaf1:eth3<br/>trunk allow vlan 5 8"| BR1
    L2 --- |"leaf2:eth3<br/>trunk allow vlan 5 8"| BR2
    
    %% Access Switch to Server
    BR1 --- |"vm1:eth1"| H1
    BR1 --- |"vm2:eth1"| H2
    BR2 --- |"vm3:eth1"| H3
    BR2 --- |"vm4:eth1"| H4

```
</div>
