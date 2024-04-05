#!md
When managing pods in Kubernetes, Cilium will create a Custom Resource Definition (CRD) of Kind CiliumEndpoint (CEP) for each pod managed by Cilium. If enable-cilium-endpoint-slice is enabled, then Cilium will also create a CRD of Kind CiliumEndpointSlice (CES) that groups a set of slim CEP objects with the same security identity together into a single CES object and broadcast CES objects to communicate identities to other agents instead of doing so via broadcasting CEP. In most cases, this reduces load on the control plane and can sustain larger-scaled cluster using the same master resource.

ces == n*cep based on Identity-Based(A series of units with the same label)

[root@wluo ~]$ k get cep -owide 
NAME         SECURITY IDENTITY   INGRESS ENFORCEMENT   EGRESS ENFORCEMENT   VISIBILITY POLICY   ENDPOINT STATE   IPV4         IPV6
wluo-k64rg   6704                <status disabled>     <status disabled>    <status disabled>   ready            10.0.1.241   
wluo-whztw   6704                <status disabled>     <status disabled>    <status disabled>   ready            10.0.0.187   
wluo-x6wp4   6704                <status disabled>     <status disabled>    <status disabled>   ready            10.0.2.211   
[root@wluo ~]$ k get pods -o wide --show-labels 
NAME         READY   STATUS    RESTARTS   AGE     IP           NODE                                           NOMINATED NODE   READINESS GATES   LABELS
wluo-k64rg   1/1     Running   0          7m19s   10.0.1.241   cilium-ciliumendpointslice-crd-control-plane   <none>           <none>            app=wluo,controller-revision-hash=c5f47bf54,pod-template-generation=1
wluo-whztw   1/1     Running   0          7m19s   10.0.0.187   cilium-ciliumendpointslice-crd-worker          <none>           <none>            app=wluo,controller-revision-hash=c5f47bf54,pod-template-generation=1
wluo-x6wp4   1/1     Running   0          7m19s   10.0.2.211   cilium-ciliumendpointslice-crd-worker2         <none>           <none>            app=wluo,controller-revision-hash=c5f47bf54,pod-template-generation=1
[root@wluo ~]$ k get ces 
NAME                  AGE
ces-5d7t44r9w-m25f8   50m
ces-g2mw9wrrx-chnfb   7m22s
ces-wlg8nqt62-88cbz   50m
[root@wluo ~]$ k get ces ces-g2mw9wrrx-chnfb -o yaml 
apiVersion: cilium.io/v2alpha1
endpoints:
- encryption: {}
  id: 6704
  name: wluo-k64rg
  networking:
    addressing:
    - ipv4: 10.0.1.241
    node: 172.18.0.3
- encryption: {}
  id: 6704
  name: wluo-x6wp4
  networking:
    addressing:
    - ipv4: 10.0.2.211
    node: 172.18.0.4
- encryption: {}
  id: 6704
  name: wluo-whztw
  networking:
    addressing:
    - ipv4: 10.0.0.187
    node: 172.18.0.2
kind: CiliumEndpointSlice
metadata:
  creationTimestamp: "2024-03-24T01:37:04Z"
  generation: 1
  name: ces-g2mw9wrrx-chnfb
  resourceVersion: "6124"
  uid: 0fd2602a-d3c5-4c58-8bea-c40393883086
namespace: default
[root@wluo ~]$  
