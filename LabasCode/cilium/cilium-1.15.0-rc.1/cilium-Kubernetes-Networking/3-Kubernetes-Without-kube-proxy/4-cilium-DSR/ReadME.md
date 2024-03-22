[root@wluo cilium-DSR]$ tree -a
.
├── cilium-LB-DSR-dsrDispatch-geneve
│   ├── 1-cilium-dsrDispatch-native-routing # 1. cilium DSR_geneve + Native Routing
│   │   ├── 1-setup-env.sh
│   │   └── cni.yaml
│   ├── 2-cilium-dsrDispatch-geneve         # 2. cilium DSR_geneve + Geneve
│   │   ├── 1-setup-env.sh
│   │   └── cni.yaml
│   └── cni.yaml
├── cilium-LB-DSR-dsrDispatch-opt           # 3. cilium DSR-OPT(IP extension header)
│   ├── 1-setup-env.sh
│   └── cni.yaml
├── cilium-LB-hybrid                        # 4. cilium LB-Hybrid
│   ├── 1-setup-env.sh
│   └── cni.yaml
└── ReadME.md
