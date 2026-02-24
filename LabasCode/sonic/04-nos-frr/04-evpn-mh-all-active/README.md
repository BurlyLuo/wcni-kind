# FRR EVPN Multihoming (EVPN-MH) — All-Active (based on `02-evpn-l2-l3-vlan`)

This lab builds an **All-Active EVPN Multihoming** Ethernet Segment using **FRR 10.5.0** on top of the working EVPN/VXLAN baseline in `../02-evpn-l2-l3-vlan`.

Key point (from FRR official EVPN Multihoming doc): the Ethernet Segment is defined in **zebra** on the **access LAG (bond)** interface:

- `evpn mh es-id <1-16777215 | name>`
- `evpn mh es-sys-mac <mac>`
- optional `evpn mh es-df-pref <0-65535>`

## Topology

- `spine` is a simple BGP RR-like core node (eBGP to leaves) and carries EVPN routes.
- `leaf1` and `leaf2` are VTEPs.
- `ce1` is a dual-homed host connected to both leaves using an LACP bond.
- The dual-homed segment is VLAN 5 (L2VNI 5000) so we can validate MAC mobility/BUM forwarding and DF election behavior.

## What to expect

- Both leafs advertise the same ES for `bond0` towards `ce1` (All-Active).
- DF election happens per EVI / VLAN (here for VLAN 5 / VNI 5000).
- With both links up, traffic works; if you bring down one uplink, connectivity stays up and EVPN MH converges.

## Files

- `clab.yaml`: containerlab topology.
- `frr/spine.conf`, `frr/leaf1.conf`, `frr/leaf2.conf`: FRR configs.
- `1-setup.sh`: deploy lab.
- `2-verify.sh`: control-plane + dataplane checks (ping + show commands).

## Quick start

```bash
cd /root/wcni-kind/LabasCode/sonic/04-nos-frr/04-evpn-mh-all-active
bash 1-setup.sh
bash 2-verify.sh
```

## Notes / assumptions

- This lab uses Linux bonding inside the leaf containers (`bond0` built from `eth2`), and inside `ce1` (`bond0` built from `eth1` + `eth2`).
- If your kernel/modules setup prevents bonding in containers, tell me and I’ll switch to a non-LACP “bridge uplink” model (still tests some behavior, but not the canonical FRR ES-on-bond model).
