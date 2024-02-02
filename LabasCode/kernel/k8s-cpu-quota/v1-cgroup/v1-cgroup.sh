#!/bin/bash
for i in $(pgrep -uroot);do taskset -cp 3-7 $i;done

docker run --name c1 -td --cpu-shares=1024 --cpuset-cpus="0,1,2" 192.168.2.100:5000/xcni
docker run --name c2 -td --cpu-shares=1024 --cpuset-cpus="0,1,2" 192.168.2.100:5000/xcni
docker run --name c3 -td --cpu-shares=1024 --cpuset-cpus="0,1,2" 192.168.2.100:5000/xcni

echo 'alias c1="docker exec -it c1 bash"' >> ~/.bashrc
echo 'alias c2="docker exec -it c2 bash"' >> ~/.bashrc
echo 'alias c3="docker exec -it c3 bash"' >> ~/.bashrc


echo "sysbench cpu --time=10000 run &"
echo "docker stop c1 c2 c3 && docker rm c1 c2 c3"

