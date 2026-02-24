#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

ok() { echo "[OK] $*"; }
info() { echo "[..] $*"; }

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing '$1'" >&2; exit 1; }
}

need docker

info "BGP summary (leaves)"
docker exec -t leaf1 vtysh -c 'show bgp summary' | sed -n '1,30p'
docker exec -t leaf2 vtysh -c 'show bgp summary' | sed -n '1,30p'

info "EVPN summary (leaves)"
docker exec -t leaf1 vtysh -c 'show bgp l2vpn evpn summary' | sed -n '1,120p'
docker exec -t leaf2 vtysh -c 'show bgp l2vpn evpn summary' | sed -n '1,120p'

info "EVPN Multihoming state (best-effort show commands; varies by FRR build)"
set +e
for n in leaf1 leaf2; do
  echo "--- $n ---"
  docker exec -t "$n" vtysh -c 'show evpn mh es' 2>/dev/null || true
  docker exec -t "$n" vtysh -c 'show zebra evpn mh es' 2>/dev/null || true
  docker exec -t "$n" vtysh -c 'show evpn es' 2>/dev/null || true
  docker exec -t "$n" vtysh -c 'show zebra evpn es' 2>/dev/null || true
  docker exec -t "$n" vtysh -c 'show evpn vni detail' 2>/dev/null | sed -n '1,160p' || true
  docker exec -t "$n" vtysh -c 'show bgp l2vpn evpn route type 1' 2>/dev/null | sed -n '1,100p' || true
  docker exec -t "$n" vtysh -c 'show bgp l2vpn evpn route type 4' 2>/dev/null | sed -n '1,100p' || true
  echo
done
set -e

info "Ping from ce1 -> leaf anycast gateway (10.1.5.254)"
docker exec -t ce1 ping -c 2 -W 1 10.1.5.254 >/dev/null
ok "ce1 can ping default gateway"

info "Ping from leaf1(VRF red) -> ce1 host IP (10.1.5.11)"
docker exec -t leaf1 ip vrf exec red ping -c 2 -W 1 10.1.5.11 >/dev/null
ok "leaf1(VRF red) can ping ce1"

info "Link-fail test: bring down leaf1<->ce1 link (leaf1 eth2) and keep pinging"
docker exec -t leaf1 ip link set eth2 down
sleep 2
# Expect still reachable via leaf2
if docker exec -t ce1 ping -c 2 -W 1 10.1.5.254 >/dev/null; then
  ok "gateway reachable after leaf1 eth2 down (via leaf2)"
else
  echo "Ping failed after link down" >&2
  docker exec -t ce1 ip a || true
  exit 1
fi

docker exec -t leaf1 ip link set eth2 up
sleep 2
ok "restored leaf1 eth2"

echo
ok "Verification completed"
