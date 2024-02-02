#!/bin/bash
set -v
wget http://192.168.2.100/k3s/go/ecapture/ecapture
chmod +x ecapture
curl --cacert server.crt https://vm22040
