#!/bin/bash
set -v 

# labels set
kubectl get pods -owide --show-labels 
# policy set
kubectl get cnp l4-rules -o jsonpath='{.spec}' | python -mjson.tool
cat <<EOF
kubectl get cnp l4-rules -o jsonpath='{.spec}' | python -mjson.tool
{
    "endpointSelector": {
        "matchLabels": {
            "env": "client-prod"
        }
    },
    "ingress": [
        {
            "fromEndpoints": [    // rule1是指fromEndpoints且label是"env": "client-dev"
                {
                    "matchLabels": {
                        "env": "client-dev"
                    }
                }
            ]
        },
        {
            "toPorts": [          // rule2是指toPorts且dst的端口是81.满足一个就满足访问条件.
                {
                    "ports": [
                        {
                            "port": "81",
                            "protocol": "TCP"
                        }
                    ]
                }
            ]
        }
    ]
}
EOF

# 1. match rules
# 1.1: match label: "env": "client-prod
client_prod_pod_ip=$(kubectl get pods -owide | grep client-prod | awk '{print $6}')
kubectl exec -it client-dev -- curl -m 1 $client_prod_pod_ip

# 1.2: match toPorts rule
client_prod_pod_ip=$(kubectl get pods -owide | grep client-prod | awk '{print $6}')
kubectl exec -it nettool -- curl -m 1 $client_prod_pod_ip
kubectl exec -it nettool -- curl -m 1 $client_prod_pod_ip:81

# not match rule1[label] and rule2[toPorts]:
kubectl exec -it nettool -- curl -m 1 $client_prod_pod_ip

