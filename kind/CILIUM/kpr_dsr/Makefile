deploy:
	kind create cluster --config cluster.yaml --image=kindest/node:v1.23.4
	./render-values.sh
	cilium install --helm-values values.yaml --wait
	kubectl apply -f k8s-resources.yaml
	kubectl rollout status ds/httpbin
	kubectl rollout status ds/netshoot

destroy:
	kind delete clusters example-kpr-dsr
	rm -f values.yaml
