deploy:
	kind create cluster --config=./kind-calico.yaml --image=kindest/node:v1.23.4
	kubectl apply -f calico.yaml
	kubectl apply -f cni.yaml
destroy:
	kind delete clusters clab-bgp-cplane-gateway
