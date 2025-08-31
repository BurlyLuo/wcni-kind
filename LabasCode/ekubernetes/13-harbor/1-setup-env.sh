kubectl apply -f ./2-metallb

kubectl apply -f deploy.yaml

helm install harbor ./
