#!/bin/bash
set -v 

# 1. Enable DSR
calicoctl --allow-version-mismatch patch felixconfiguration default --patch='{"spec": {"bpfExternalServiceMode": "DSR"}}'

