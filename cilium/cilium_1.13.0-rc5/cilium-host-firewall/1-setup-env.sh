# Ever since its inception, Cilium has supported Kubernetes Network Policies to enforce traffic control to and from pods at L3/L4.
# But Cilium Network Policies even go even further: by leveraging eBPF, it can provide greater visibility into packets and enforce traffic policies at L7 and can filter traffic based on criteria such as FQDN, protocol (such as kafka, grpc), etc...
#/bin/bash
set -v

cat /etc/kind/${KIND_CONFIG}.yaml
---
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  # localhost.run proxy
  - containerPort: 32042
    hostPort: 32042
  # Hubble relay
  - containerPort: 31234
    hostPort: 31234
  # Hubble UI
  - containerPort: 31235
    hostPort: 31235
  extraMounts:
  - hostPath: /opt/images
    containerPath: /opt/images
- role: worker
  extraMounts:
  - hostPath: /opt/images
    containerPath: /opt/images
- role: worker
  extraMounts:
  - hostPath: /opt/images
    containerPath: /opt/images
networking:
  disableDefaultCNI: true

