#/bin/bash
set -v 

wget http://192.168.2.100/k3s/go/ecapture/ecapture
chmod +x ecapture

ifname=lo
./ecapture tls -i $ifname -w mTLS.cap

# mTLS requests:
./server &
pid=$(echo $i)

curl --trace trace.log -k --cacert ./certs/ca.crt --cert ./certs/client.b.crt --key ./certs/client.b.key https://localhost:8443/hello

kill -9 $(pgrep ecapture)
rm -rf ./ecapture
kill -9 $pid
