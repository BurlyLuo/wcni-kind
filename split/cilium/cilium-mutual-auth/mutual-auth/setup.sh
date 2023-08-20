#!/bin/bash

kubectl create ns app-routable-demo
kubectl apply -n app-routable-demo -f ./app/nginx-conf-map.yaml
kubectl apply -n app-routable-demo -f ./app/zone_svc.yaml
kubectl apply -n app-routable-demo -f ./app/echoserver1.yaml
kubectl apply -n app-routable-demo -f ./app/echoserver2.yaml
kubectl apply -n app-routable-demo -f ./app/nginx-zone.yaml
kubectl apply -n app-routable-demo -f ./app/siege.yaml
kubectl get po -n app-routable-demo

echo 'Run for example: kubectl run -it -n app-routable-demo --rm --image xxradar/hackon mycurler -- bash'
echo 'Issue for example:  curl -v -H "Cookie: loc=client" http://zone1/app3'


