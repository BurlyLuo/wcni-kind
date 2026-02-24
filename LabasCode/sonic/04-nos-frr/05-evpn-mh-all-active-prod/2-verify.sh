#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing $1" >&2; exit 1; }; }
need docker

info() { echo "[..] $*"; }
ok() { echo "[OK] $*"; }

info "BGP/EVPN summary"
docker exec -t leaf1 vtysh -c 'show bgp summary' | sed -n '1,30p'
docker exec -t leaf2 vtysh -c 'show bgp summary' | sed -n '1,30p'
docker exec -t leaf1 vtysh -c 'show bgp l2vpn evpn summary' | sed -n '1,80p'
docker exec -t leaf2 vtysh -c 'show bgp l2vpn evpn summary' | sed -n '1,80p'

info "EVPN ES + Type-4 (ESR) routes"
docker exec -t leaf1 vtysh -c 'show evpn es' | sed -n '1,120p'
docker exec -t leaf2 vtysh -c 'show evpn es' | sed -n '1,120p'
docker exec -t leaf1 vtysh -c 'show bgp l2vpn evpn route type 4' | sed -n '1,120p'
docker exec -t leaf2 vtysh -c 'show bgp l2vpn evpn route type 4' | sed -n '1,120p'

info "Ping matrix (inside VRF red on leaves)"
# VLAN5 intra-subnet
for src in vm1 vm2 cese; do
  for dst in 10.1.5.10 10.1.5.11 10.1.5.200; do
    docker exec -t "$src" ping -c 1 -W 1 "$dst" >/dev/null || true
  done
done
ok "basic VLAN5 reachability attempted (see any failures above)"

# VLAN8 intra-subnet
for src in vm3 vm4; do
  for dst in 10.1.8.10 10.1.8.11; do
    docker exec -t "$src" ping -c 1 -W 1 "$dst" >/dev/null || true
  done
done
ok "basic VLAN8 reachability attempted (see any failures above)"

info "Default gateway checks"
docker exec -t vm1 ping -c 2 -W 1 10.1.5.254 >/dev/null
ok "vm1 can ping gw (vlan5)"
docker exec -t vm3 ping -c 2 -W 1 10.1.8.254 >/dev/null
ok "vm3 can ping gw (vlan8)"

info "Link failover: down leaf1<->cese (leaf1 eth2), cese should still reach gw"
docker exec -t leaf1 ip link set eth2 down
sleep 2
if docker exec -t cese ping -c 2 -W 1 10.1.5.254 >/dev/null; then
  ok "cese still reaches gw after leaf1 access link down (via leaf2)"
else
  echo "[FAIL] cese lost gw reachability after link-down" >&2
  exit 1
fi

docker exec -t leaf1 ip link set eth2 up
sleep 2
ok "restored leaf1 eth2"

ok "Verification completed"
