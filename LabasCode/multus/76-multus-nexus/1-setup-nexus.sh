# Setup nexus
mkdir -p /home/nexus/data && chmod 777 /home/nexus/data
docker run -d --name nexus -p 8081:8081 --restart always -v /home/nexus/data:/nexus-data 192.168.2.100:5000/sonatype/nexus3:latest
sleep 5
docker exec -it nexus cat /opt/sonatype/sonatype-work/nexus3/admin.password

# Helm index
http://192.168.2.99:8081/repository/hr/index.yaml

# Upload helm chart:
curl -u <username>:<password> http://<host>:<port>/repository/<repository_name>/ --upload-file mysql-1.4.0.tgz -v
curl -u admin:Nsn1234! http://192.168.2.99:8081/repository/hr/ --upload-file nested-asbc-helm-charts-0.0.1.tgz -v

