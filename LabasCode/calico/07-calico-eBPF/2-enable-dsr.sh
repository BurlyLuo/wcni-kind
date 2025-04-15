#!/bin/bash
set -v 

# 1. Enable DSR
calicoctl patch felixconfiguration default --patch='{"spec": {"bpfExternalServiceMode": "DSR"}}'

# DST TOPO 
cat <<EOF
                  SYN                       SYN[VxLAN]
Local_IP[11.1.1.1]--->LB1_NODE:32000[11.1.1.2]--->LB2_NODE(BackendNode)[11.1.1.3]-|
         |                                                                        |
         |------------------------------------------------------------------------|                  
                                         SYN+ACK
EOF
