#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if command -v clab >/dev/null 2>&1; then
  clab destroy -t clab.yaml --cleanup || true
fi

clab deploy -t clab.yaml

echo
echo "Lab deployed. Next: bash 2-verify.sh"
