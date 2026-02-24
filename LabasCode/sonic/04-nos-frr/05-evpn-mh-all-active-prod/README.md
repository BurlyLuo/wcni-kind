# FRR EVPN-MH — All-Active, VLAN-aware bridge (prod-ish)

This lab is a more **production-like** EVPN design:

- EVPN/VXLAN **VLAN-aware bridge** (SVD style): one vxlan device (`vxlan0`) with VLAN<->VNI mappings.
- Two L2 segments over EVPN:
  - VLAN 5 / VNI 5000: `10.1.5.0/24`
  - VLAN 8 / VNI 8000: `10.1.8.0/24`
- VRF `red` with **L3VNI 100** (VLAN 100 / VNI 100) like the baseline examples.
- **EVPN Multihoming (All-Active)** for a dual-homed CE (`cese`) into **VLAN 5** using LACP bond on both leaves.

Also includes four single-homed hosts:
- VLAN 5: `vm1=10.1.5.10`, `vm2=10.1.5.11`
- VLAN 8: `vm3=10.1.8.10`, `vm4=10.1.8.11`

## How EVPN-MH is configured (FRR official concept)

On both leaves, the ES is configured in zebra on the access LAG:

```
interface bond0
 evpn mh es-id 1
 evpn mh es-sys-mac 44:38:39:ff:00:01
 evpn mh es-df-pref <...>
```

## Try it

```bash
cd /root/wcni-kind/LabasCode/sonic/04-nos-frr/05-evpn-mh-all-active-prod
bash 1-setup.sh
bash 2-verify.sh
```

## Notes

- The CE (`cese`) bonds two links (one to each leaf) using LACP. Leaves also use `bond0` on the access side.
- Gateways are on the leaves via VLAN subif on `br0` (inside VRF `red`).
