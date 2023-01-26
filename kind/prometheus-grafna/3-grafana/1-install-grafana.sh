helm repo add grafana https://grafana.github.io/helm-charts

helm install --set name=grafana  grafana ./2-grafana/

kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-server

kubectl get svc  | grep grafana
echo "User: admin"
echo "Password: $(kubectl get secret grafana-admin --namespace default -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 --decode)"
