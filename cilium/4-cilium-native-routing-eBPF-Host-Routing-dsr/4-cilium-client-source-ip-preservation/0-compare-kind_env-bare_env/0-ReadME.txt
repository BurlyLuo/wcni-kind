$ This topic need compate with other CNI. Calico is a pretty one.
Reference env: Calico ENV:
HOST: 192.168.2.66   Path: git@gitee.com:rowan-wcni/kind.git/CALICO/calico-bgp
Calico Env DataPath:
------------------------------------------------------------------------------------------------------------------------------------------------------------
root@hive:~# ds
CONTAINER ID   IMAGE                  COMMAND                  CREATED       STATUS       PORTS                       NAMES
a4b12875caa7   kindest/node:v1.25.3   "/usr/local/bin/entr…"   2 hours ago   Up 2 hours                               calico-bgp-worker
481c08afeca6   kindest/node:v1.25.3   "/usr/local/bin/entr…"   2 hours ago   Up 2 hours                               calico-bgp-worker2
975b564cf2dc   kindest/node:v1.25.3   "/usr/local/bin/entr…"   2 hours ago   Up 2 hours   127.0.0.1:37377->6443/tcp   calico-bgp-control-plane
root@hive:~# dip
NAME                       STATUS   ROLES           AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
calico-bgp-control-plane   Ready    control-plane   135m   v1.25.3   172.18.0.4    <none>        Ubuntu 22.04.1 LTS   5.15.0-53-generic   containerd://1.6.9
calico-bgp-worker          Ready    <none>          134m   v1.25.3   172.18.0.3    <none>        Ubuntu 22.04.1 LTS   5.15.0-53-generic   containerd://1.6.9
calico-bgp-worker2         Ready    <none>          134m   v1.25.3   172.18.0.5    <none>        Ubuntu 22.04.1 LTS   5.15.0-53-generic   containerd://1.6.9
root@hive:~# kubectl get pods -owide 
NAME                         READY   STATUS    RESTARTS   AGE    IP             NODE                 NOMINATED NODE   READINESS GATES
calico-bgp-d559cb6bc-d8f8x   1/1     Running   0          128m   10.244.49.65   calico-bgp-worker2   <none>           <none>
root@hive:~# k get svc -owide 
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE    SELECTOR
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP          135m   <none>
serversvc    NodePort    10.96.53.100   <none>        8080:32000/TCP   132m   app=calico-bgp
root@hive:~# 

$ 1. we can set the Service: serversvc externalTrafficPolicy=Local  !!!
root@hive:~# k get svc serversvc -o yaml 
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"serversvc","namespace":"default"},"spec":{"ports":[{"name":"cni","nodePort":32000,"port":8080,"targetPort":80}],"selector":{"app":"calico-bgp"},"type":"NodePort"}}
  creationTimestamp: "2022-11-23T07:36:03Z"
  name: serversvc
  namespace: default
  resourceVersion: "1812"
  uid: a86699b9-e428-4fff-80b4-5ed060e1063e
spec:
  clusterIP: 10.96.53.100
  clusterIPs:
  - 10.96.53.100
  externalTrafficPolicy: Local    // Change the value from Cluster into Local!!!
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: cni
    nodePort: 32000
    port: 8080
    protocol: TCP
    targetPort: 80
  selector:
    app: calico-bgp
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}
root@hive:~# 


$ The backend pod is at node: calico-bgp-worker2
root@hive:~# dip
NAME                       STATUS   ROLES           AGE    VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
calico-bgp-control-plane   Ready    control-plane   135m   v1.25.3   172.18.0.4    <none>        Ubuntu 22.04.1 LTS   5.15.0-53-generic   containerd://1.6.9
calico-bgp-worker          Ready    <none>          134m   v1.25.3   172.18.0.3    <none>        Ubuntu 22.04.1 LTS   5.15.0-53-generic   containerd://1.6.9
calico-bgp-worker2         Ready    <none>          134m   v1.25.3   172.18.0.5    <none>        Ubuntu 22.04.1 LTS   5.15.0-53-generic   containerd://1.6.9
We can trigger a request from the calico-bgp-control-plane

root@hive:~# lo calico-bgp-control-plane curl 172.18.0.4:32000
PodName: calico-bgp-d559cb6bc-d8f8x | PodIP: eth0 10.244.49.65/32
root@hive:~# lo calico-bgp-control-plane curl 172.18.0.3:32000
^C    // If curl 172.18.0.3(calico-bgp-worker). It failed. Pls Note: The traffice is from node: calico-bgp-control-plane
      // If back to externalTrafficPolicy: Cluster, all the ip can be worked fine.

root@hive:~# lo calico-bgp-control-plane curl 172.18.0.5:32000
PodName: calico-bgp-d559cb6bc-d8f8x | PodIP: eth0 10.244.49.65/32
root@hive:~# 
$ This is the beavhior of the Calico CNI. The folwing is the Cilium CNI.
------------------------------------------------------------------------------------------------------------------------------------------------------------
Cilium v1.12.0 Env with externalTrafficPolicy: Local
$  kubectl get nodes -owide 
NAME   STATUS   ROLES                  AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
bpf1   Ready    control-plane,master   19d   v1.23.4   192.168.2.71   <none>        Ubuntu 20.04.5 LTS   5.15.0-52-generic   docker://20.10.21
bpf2   Ready    <none>                 19d   v1.23.4   192.168.2.72   <none>        Ubuntu 20.04.5 LTS   5.15.0-52-generic   docker://20.10.21
bpf3   Ready    <none>                 19d   v1.23.4   192.168.2.73   <none>        Ubuntu 20.04.5 LTS   5.15.0-52-generic   docker://20.10.21

$ k get svc -owide 
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE   SELECTOR
dsr          NodePort    10.101.168.25   <none>        80:30871/TCP   45h   app=dsr  // Test Demo Service 

$ kubectl get svc dsr -o yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: "2022-11-21T12:40:33Z"
  labels:
    app: dsr
  name: dsr
  namespace: default
  resourceVersion: "357862"
  uid: eee2b36d-a85d-4f73-a18c-8f49718a15fa
spec:
  clusterIP: 10.101.168.25
  clusterIPs:
  - 10.101.168.25
  externalTrafficPolicy: Local // This parameter
  internalTrafficPolicy: Local
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 30871
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: dsr
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}
root@bpf1:~#

$ curl 192.168.2.71:30871                        // 192.168.2.71
PodName: dsr-68876f9dcc-jv65p | PodIP: eth0 10.244.2.16/32 
$ curl 192.168.2.72:30871                        // 192.168.2.72
PodName: dsr-68876f9dcc-jv65p | PodIP: eth0 10.244.2.16/32
$ curl 192.168.2.73:30871                        // 192.168.2.73
PodName: dsr-68876f9dcc-jv65p | PodIP: eth0 10.244.2.16/32


