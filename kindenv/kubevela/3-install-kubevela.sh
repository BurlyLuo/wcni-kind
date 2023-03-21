helm repo add kubevela https://charts.kubevela.net/core
helm repo update

helm search repo kubevela
helm pull kubevela/vela-core --version=1.7.6

helm install --create-namespace -n vela-system kubevela kubevela/vela-core --version=1.7.6 --set multicluster.enabled=true --wait
