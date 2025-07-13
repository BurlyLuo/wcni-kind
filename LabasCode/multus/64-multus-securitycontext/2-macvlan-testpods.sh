#!/bin/bash
set -v 

cat <<EOF | kubectl apply -f -
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: macvlan-whereabouts-conf
spec:
  config: '{
      "cniVersion": "0.3.0",
      "name": "whereaboutsexample",
      "type": "macvlan",
      "master": "eth0",
      "mode": "bridge",
      "ipam": {
        "type": "whereabouts",
        "range": "15.15.1.200-15.15.1.205/24"
      }
    }'
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: mav
  annotations:
    k8s.v1.cni.cncf.io/networks: macvlan-whereabouts-conf@eth1
spec:
  # kubectl explain pod.spec.securityContext
  securityContext:
    runAsNonRoot: true

  containers:
  - name: nginx
    image: nginxinc/nginx-unprivileged:latest
    env:
    - name: TZ
      value: "Asia/Shanghai" 
    # kubectl explain pod.spec.containers.securityContext
    securityContext:
      runAsUser: 101
      runAsGroup: 101
      allowPrivilegeEscalation: false

      privileged: false
      capabilities:
        add: ["NET_ADMIN"]

    livenessProbe:
      httpGet:
        port: 8080
        path: /index.html
      initialDelaySeconds: 30
      successThreshold: 1
      periodSeconds: 5
      failureThreshold: 5
      timeoutSeconds: 3

    readinessProbe:
      exec:
        command:
        - cat
        - /product_name
      initialDelaySeconds: 35
      successThreshold: 1
      periodSeconds: 5
      failureThreshold: 5
      timeoutSeconds: 3

    volumeMounts:
    - name: nginx-data
      mountPath: /data

  volumes:
  - name: nginx-data
    persistentVolumeClaim:
      claimName: nginx-pvc
EOF

cat <<EOF
if Probe failed:
"kubectl logs mav --previous"


# kubectl get pods -owide 
NAME   READY   STATUS              RESTARTS   AGE   IP       NODE                       NOMINATED NODE   READINESS GATES
mav    0/1     ContainerCreating   0          0s    <none>   cni-multus-control-plane   <none>           <none>
mav    0/1     ContainerCreating   0          1s    <none>   cni-multus-control-plane   <none>           <none>
mav    0/1     ContainerCreating   0          1s    <none>   cni-multus-control-plane   <none>           <none>
mav    0/1     Running             0          4s    10.244.226.135   cni-multus-control-plane   <none>           <none>
mav    1/1     Running             0          41s   10.244.226.135   cni-multus-control-plane   <none>           <none>
^C[root@rowan> 63-multus-probe]# 
EOF
