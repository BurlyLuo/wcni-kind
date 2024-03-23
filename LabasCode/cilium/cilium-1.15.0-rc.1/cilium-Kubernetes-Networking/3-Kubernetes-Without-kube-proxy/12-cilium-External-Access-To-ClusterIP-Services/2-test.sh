#!/bin/bash
echo "Cilium does not allow external access to ClusterIP SVC by default, you can enable it with bpf.lbExternalClusterIP=true. However, you need to break the relevant routes yourself."
