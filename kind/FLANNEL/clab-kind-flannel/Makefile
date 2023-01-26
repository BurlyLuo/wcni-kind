deploy:
	kind create cluster --config=./kind-flannel.yaml --image=kindest/node:v1.23.4
	./create-bridge.sh
	clab -t topo.yaml deploy
	./hook.sh
destroy:
	clab -t topo.yaml destroy
	kind delete clusters clab-kind-flannel-vxlan
