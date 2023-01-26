
#https://github.com/prometheus-community/helm-charts

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install --set name=prometheus prometheus ./2-prometheus

kubectl get pods -n default -o wide 

kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prom-server



