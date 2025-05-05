#!/bin/bash
set -v 

# labels set
kubectl get pods -owide --show-labels 
# policy set
kubectl get cnp l7-rules -o jsonpath='{.spec}' | python -mjson.tool
cat <<EOF
kubectl get cnp l7-rules -o jsonpath='{.spec}' | python -mjson.tool
{
    "description": "Allow HTTP GET / from env=client-dev to env= client-prod",
    "endpointSelector": {
        "matchLabels": {
            "env": "client-prod"
        }
    },
    "ingress": [   //全部满足条件才可以. fromEndpoints && toPorts && ports && http && method && path
        {
            "fromEndpoints": [
                {
                    "matchLabels": {
                        "env": "client-dev"
                    }
                }
            ],
            "toPorts": [
                {
                    "ports": [
                        {
                            "port": "80",
                            "protocol": "TCP"
                        }
                    ],
                    "rules": {
                        "http": [
                            {
                                "method": "GET",
                                "path": "/"
                            }
                        ]
                    }
                }
            ]
        }
    ]
}
EOF

# 1. match rules
client_prod_pod_ip=$(kubectl get pods -owide | grep client-prod | awk '{print $6}')
kubectl exec -it client-dev -- curl -m 1 $client_prod_pod_ip:80/

# 1.2: not match rule
client_prod_pod_ip=$(kubectl get pods -owide | grep client-prod | awk '{print $6}')
kubectl exec -it nettool -- curl -m 1 $client_prod_pod_ip
# 1.3: not match path rule
kubectl exec -it client-dev -- curl -m 1 $client_prod_pod_ip:80/123

