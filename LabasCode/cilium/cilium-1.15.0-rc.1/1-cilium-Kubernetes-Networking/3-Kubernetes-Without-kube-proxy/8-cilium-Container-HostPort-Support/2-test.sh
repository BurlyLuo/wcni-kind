#/bin/bash
kubectl -nkube-system exec -it ds/cilium -c cilium-agent -- cilium service list

