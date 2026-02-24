#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

clab destroy -t clab.yaml --cleanup || true
clab deploy -t clab.yaml

echo "Deployed. Next: bash 2-verify.sh"
