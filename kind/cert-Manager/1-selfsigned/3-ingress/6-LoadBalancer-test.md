kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.18.0.203-172.18.0.210
      
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-metallb-test
spec:
  selector:
    matchLabels:
      app: nginx-metallb-test
  template:
    metadata:
      labels:
        app: nginx-metallb-test
    spec:
      containers:
      - name: nginx
        image: nginx:1.8
        ports:
        - name: http
          containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx-metallb-test
  type: LoadBalancer
