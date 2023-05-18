#/bin/bash
set -v
exec &>./cilium-gateway-api-http.log
# case ubuntu 22.04
GATEWAY=$(kubectl get gateway my-gateway -o jsonpath='{.status.addresses[0].value}')
curl -v http://"$GATEWAY"/details/1 | jq

# case ubuntu 20.04. 192.168.2.10 Chrom
# $ http://192.168.2.200/details/1
# $ {"id":1,"author":"William Shakespeare","year":1595,"type":"paperback","pages":200,"publisher":"PublisherA","language":"English","ISBN-10":"1234567890","ISBN-13":"123-1234567890"}
