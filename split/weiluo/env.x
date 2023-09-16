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

root@2204:~/wcni-kind/split# multipass version 
multipass   1.12.2
multipassd  1.12.2
root@2204:~/wcni-kind/split# 

root@2204:~/wcni-kind/split/weiluo# kind version 
kind v0.20.0 go1.20.4 linux/amd64
root@2204:~/wcni-kind/split/weiluo# 

root@2204:~/wcni-kind/split/weiluo# clab version 

                           _                   _       _     
                 _        (_)                 | |     | |    
 ____ ___  ____ | |_  ____ _ ____   ____  ____| | ____| | _  
/ ___) _ \|  _ \|  _)/ _  | |  _ \ / _  )/ ___) |/ _  | || \ 
( (__| |_|| | | | |_( ( | | | | | ( (/ /| |   | ( ( | | |_) )
\____)___/|_| |_|\___)_||_|_|_| |_|\____)_|   |_|\_||_|____/ 

    version: 0.42.0
     commit: 27689089
       date: 2023-06-17T12:45:12Z
     source: https://github.com/srl-labs/containerlab
 rel. notes: https://containerlab.dev/rn/0.42/


6. Cilium clustermesh deploy muti-cluster faliure:
cat <<EOF>>/etc/sysctl.conf
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
EOF
sysctl -p




