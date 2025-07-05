kubectl exec -it redis0-0 -- bash -c "redis-cli --cluster create 192.168.1.190:6379 192.168.1.191:6379 192.168.1.192:6379 --cluster-replicas 2 --cluster-yes"
