wget http://192.168.2.100/k3s/go/go1.23.2.linux-amd64.tar.gz -P / && tar -C /usr/local -xzf /go1.23.2.linux-amd64.tar.gz
export GOPATH=$HOME/go && export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
go env -w GO111MODULE=on && go env -w GOPROXY=https://goproxy.cn,direct

wget http://192.168.2.100/k3s/go/ipsecdump.tgz -P / && tar -xzvf /ipsecdump.tgz && cd /ipsecdump-master && go build && cp -r /ipsecdump-master/ipsecdump /usr/bin/ && chmod +x /usr/bin/ipsecdump

