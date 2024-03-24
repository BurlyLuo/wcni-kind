#/bin/bash
[root@wluo 4-cilium-Endpoint-CRD]$ k get ciliumendpoint -o wide 
NAME         SECURITY IDENTITY   INGRESS ENFORCEMENT   EGRESS ENFORCEMENT   VISIBILITY POLICY   ENDPOINT STATE   IPV4         IPV6
wluo-mvz4t   48861               <status disabled>     <status disabled>    <status disabled>   ready            10.0.1.200   
wluo-z6hvb   18965               <status disabled>     <status disabled>    <status disabled>   ready            10.0.2.189   
wluo-zjzgr   18965               <status disabled>     <status disabled>    <status disabled>   ready            10.0.0.131   
[root@wluo 4-cilium-Endpoint-CRD]$ k get pods -owide 
NAME         READY   STATUS    RESTARTS   AGE   IP           NODE                       NOMINATED NODE   READINESS GATES
wluo-mvz4t   1/1     Running   0          11h   10.0.1.200   cilium-kpr-worker2         <none>           <none>
wluo-z6hvb   1/1     Running   0          11h   10.0.2.189   cilium-kpr-worker          <none>           <none>
wluo-zjzgr   1/1     Running   0          11h   10.0.0.131   cilium-kpr-control-plane   <none>           <none>
[root@wluo 4-cilium-Endpoint-CRD]$ k get ciliumendpoint wluo-mvz4t -o json
{
    "apiVersion": "cilium.io/v2",
    "kind": "CiliumEndpoint",
    "metadata": {
        "creationTimestamp": "2024-03-23T13:05:09Z",
        "generation": 1,
        "labels": {
            "app": "wluo",
            "controller-revision-hash": "55c988885f",
            "pod-template-generation": "1"
        },
        "name": "wluo-mvz4t",
        "namespace": "default",
        "ownerReferences": [
            {
                "apiVersion": "v1",
                "kind": "Pod",
                "name": "wluo-mvz4t",
                "uid": "90b353f5-53a1-4d98-8204-8adf1156ecec"
            }
        ],
        "resourceVersion": "933",
        "uid": "798c2fec-5eb1-4906-a301-517607560d90"
    },
    "status": {
        "encryption": {},
        "external-identifiers": {
            "cni-attachment-id": "ad4a629c6b8fc5d4f5f4d205a64d2a22ad256d5a937051c735a59b2cdd4f61e7:eth0",
            "container-id": "ad4a629c6b8fc5d4f5f4d205a64d2a22ad256d5a937051c735a59b2cdd4f61e7",
            "k8s-namespace": "default",
            "k8s-pod-name": "wluo-mvz4t",
            "pod-name": "default/wluo-mvz4t"
        },
        "id": 457,
        "identity": {
            "id": 48861,
            "labels": [
                "k8s:app=wluo",
                "k8s:io.cilium.k8s.namespace.labels.kubernetes.io/metadata.name=default",
                "k8s:io.cilium.k8s.policy.cluster=cilium-kpr",
                "k8s:io.cilium.k8s.policy.serviceaccount=default",
                "k8s:io.kubernetes.pod.namespace=default"
            ]
        },
        "networking": {
            "addressing": [
                {
                    "ipv4": "10.0.1.200"
                }
            ],
            "node": "172.18.0.3"
        },
        "policy": {
            "egress": {
                "enforcing": false,
                "state": "\u003cstatus disabled\u003e"
            },
            "ingress": {
                "enforcing": false,
                "state": "\u003cstatus disabled\u003e"
            }
        },
        "state": "ready",
        "visibility-policy-status": "\u003cstatus disabled\u003e"
    }
}
[root@wluo 4-cilium-Endpoint-CRD]$ 
