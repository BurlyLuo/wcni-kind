# VyOS VXLAN BGP EVPN

<div align="center">

```mermaid
graph TB
    subgraph "AS 65010"
        RR1["RR1<br/>BGP RR"]
        RR2["RR2<br/>BGP RR"]
        R1["R1<br/>dum0:172.29.0.1/32"]        
        R2["R2<br/>dum0:172.29.0.2/32"]
        R3["R3<br/>dum0:172.29.0.3/32"]        
    end

    PC1["PC1<br/>eth1:10.1.5.1/24"]
    PC2["PC2<br/>eth1:10.1.5.2/24"]
    PC3["PC3<br/>eth1:10.1.5.3/24"]

    
    %% links
    RR1 --- |"RR1:eth1:172.29.1.0/31<br/>↔<br/>R1:eth1:172.29.1.1/31"| R1
    RR1 --- |"RR1:eth2:172.29.1.2/31<br/>↔<br/>R1:eth1:172.29.1.3/31"| R2
    RR1 --- |"RR1:eth3:172.29.1.4/31<br/>↔<br/>R1:eth1:172.29.1.5/31"| R3

    RR2 --- |"RR2:eth1:172.29.2.0/31<br/>↔<br/>R1:eth1:172.29.2.1/31"| R1
    RR2 --- |"RR2:eth2:172.29.2.2/31<br/>↔<br/>R1:eth1:172.29.2.3/31"| R2
    RR2 --- |"RR2:eth3:172.29.2.4/31<br/>↔<br/>R1:eth1:172.29.2.5/31"| R3

    R1 --- |"R1:eth1:n/a<br/>↔<br/>PC1:eth1:10.1.5.1/24"| PC1
    R2 --- |"R2:eth1:n/a<br/>↔<br/>PC1:eth1:10.1.5.2/24"| PC2
    R3 --- |"R3:eth1:n/a<br/>↔<br/>PC1:eth1:10.1.5.3/24"| PC3
```
</div>

```shell
# R1 VXLAN config:
set interfaces vxlan vxlan100 parameters nolearning
set interfaces vxlan vxlan100 port '4789'
set interfaces vxlan vxlan100 source-address '172.29.0.1'
set interfaces vxlan vxlan100 vni '100'

set interfaces bridge br100 member interface eth3
set interfaces bridge br100 member interface vxlan100
```