#/bin/bash
date
set -v

# 1. wait pods ready
kubectl wait --timeout=100s --for=condition=Ready=true pods --all

# 2. ping test


