
cat <<EOF | kubectl apply -f -
apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
  name: "l7-visibility"
spec:
  endpointSelector:
    matchLabels:
      "k8s:io.kubernetes.pod.namespace": default
  egress:
  - toPorts:
    - ports:
      - port: "53"
        protocol: ANY
      rules:
        dns:
        - matchPattern: "*"
  - toEndpoints:
    - matchLabels:
        "k8s:io.kubernetes.pod.namespace": default
    toPorts:
    - ports:
      - port: "80"
        protocol: TCP
      - port: "8080"
        protocol: TCP
      rules:
        http: [{}]
EOF

kill -9 $(ps -ef | grep "cilium hubble port-forward" | awk '{print $2}') > /dev/null 2>&1 || true

cilium hubble port-forward &
sleep 5

hubble observe -f -t l7 -o compact

# k exec ds/wluo -- curl wluo
