#calico v3.23.2 image list
#docker.io/calico/cni:v3.23.2
#docker.io/calico/cni:v3.23.2
#docker.io/calico/node:v3.23.2
#docker.io/calico/kube-controllers:v3.23.2

for i in $(cat calico.yaml | grep image| awk -F "image: " '{print $2}');do echo $i; docker pull $i;done
