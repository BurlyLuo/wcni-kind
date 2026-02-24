#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing $1" >&2; exit 1; }; }
need docker

info() { echo "[..] $*"; }
ok() { echo "[OK] $*"; }

info "BGP EVPN summaries"
for n in leaf1 leaf2 leaf3 leaf4; do
  echo "--- $n ---"
  docker exec -t "$n" vtysh -c 'show bgp l2vpn evpn summary' | sed -n '1,50p'
  echo
done

info "ES visibility"
for n in leaf1 leaf2 leaf3 leaf4; do
  echo "--- $n ---"
  docker exec -t "$n" vtysh -c 'show evpn es' | sed -n '1,60p'
  docker exec -t "$n" vtysh -c 'show bgp l2vpn evpn route type 4' | sed -n '1,80p'
  echo
done

info "Cross-subnet pings (expected distributed GW behavior)"
# vm1(vlan5, segA) -> vm4(vlan8, segB)
docker exec -t vm1 ping -c 2 -W 1 10.1.8.11 | sed -n '1,6p'
# vm2(vlan5, segB) -> vm3(vlan8, segA)
docker exec -t vm2 ping -c 2 -W 1 10.1.8.10 | sed -n '1,6p'

ok "verification completed"
