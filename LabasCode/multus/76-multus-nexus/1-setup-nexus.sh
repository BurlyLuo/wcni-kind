mkdir -p /home/nexus/data
docker run -d --name nexus -p 8081:8081 --restart always -v /home/nexus/data:/nexus-data 192.168.2.100:5000/sonatype/nexus3:latest
sleep 5
docker exec -it nexus cat /opt/sonatype/sonatype-work/nexus3/admin.password
