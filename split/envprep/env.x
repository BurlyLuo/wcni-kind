1. Workhome env
$ uname -r 
6.2.0-31-generic
$ lsb_release -a 
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.2 LTS
Release:        22.04
Codename:       jammy


2. kindest/node image
docker pull burlyluo/kindest:v1.27.3
or
docker pull quay.io/weiluo/kindest/node:v1.27.3

3. nettool image
docker pull burlyluo/nettool:latest
or
docker pull quay.io/weiluo/nettool

4. vyos image
docker pull burlyluo/vyos:1.4.7
or 
docker pull quay.io/weiluo/vyos:1.4.7

5. if install docker. the FORWARD will be set -j DROP. and the basical test will failure.
Like eth0--ns1--bridge[br0]--ns2--eth2 


