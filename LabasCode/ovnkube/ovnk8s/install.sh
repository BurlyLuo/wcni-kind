
tar -xzvf /root/go1.21.1.linux-amd64.tar.gz
mv go /usr/local/
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile > /dev/null 2>&1

apt update
apt -y install python3-pip
apt -y install make

go env -w GO111MODULE=auto
go get github.com/ovn-org/ovn-kubernetes && cd $(go env GOPATH)/src/github.com/ovn-org/ovn-kubernetes

pushd go-controller
make
popd


pushd dist/images
make ubuntu
popd


pushd contrib
apt -y install jq
echo 'export KUBECONFIG=/root/ovn.conf' >> ~/.bashrc
source ~/.bashrc
./kind.sh
popd

kubectl get nodes -owide
kubectl get pods --all-namespaces

