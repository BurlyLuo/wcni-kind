# EVPN-MH + Anycast GW (Distributed SVI) — 2 segments, 4 leaves

This lab is a clean re-do to match the intended topology:

- **Segment A** (dual-homed hosts):
  - `vm1` (VLAN5, 10.1.5.10/24, GW 10.1.5.254) connects to **leaf1 + leaf2** (EVPN-MH)
  - `vm3` (VLAN8, 10.1.8.10/24, GW 10.1.8.254) connects to **leaf1 + leaf2** (EVPN-MH)

- **Segment B** (dual-homed hosts):
  - `vm2` (VLAN5, 10.1.5.11/24, GW 10.1.5.254) connects to **leaf3 + leaf4** (EVPN-MH)
  - `vm4` (VLAN8, 10.1.8.11/24, GW 10.1.8.254) connects to **leaf3 + leaf4** (EVPN-MH)

Overlay:
- VLAN 5 <-> VNI 5000
- VLAN 8 <-> VNI 8000
- VRF `red` with L3VNI 100 (VNI 100)

EVPN-MH ES:
- Segment A ES on `leaf1/leaf2` bond0: `es-id 1`, `es-sys-mac 44:38:39:ff:00:01`
- Segment B ES on `leaf3/leaf4` bond0: `es-id 2`, `es-sys-mac 44:38:39:ff:00:02`

## Run

```bash
cd /root/wcni-kind/LabasCode/sonic/04-nos-frr/06-evpn-mh-aigw-2seg
bash 1-setup.sh
bash 2-verify.sh
```
