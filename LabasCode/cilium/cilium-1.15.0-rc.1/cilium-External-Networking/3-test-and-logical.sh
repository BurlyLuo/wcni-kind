kubectl create ns egress-access
kubectl create ns egress-noaccess

kubectl -n egress-access run cni --image=192.168.2.100:5000/nettool
kubectl -n egress-noaccess run cni --image=192.168.2.100:5000/nettool

cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2
kind: CiliumEgressGatewayPolicy
metadata:
  name: egress-access
spec:
  destinationCIDRs:
  - "11.1.8.0/24"
  selectors:
  - podSelector:
      matchLabels:
        io.kubernetes.pod.namespace: egress-access
  egressGateway:
    nodeSelector:
      matchLabels:
        egress-gw: 'true'
    interface: eth9
EOF

kubectl -negress-access exec -it cni -- curl 11.1.8.10
kubectl -negress-noaccess exec -it cni -- curl --connect-timeout 2 11.1.8.10







# Cilium Egress Flow
cat <<EOF
1. test_pod(cni) curl the ext-network instance(like ext-client), in my lab, the ext-client ip: 11.1.8.10

test_pod(cni) --at-- cilium-egress-gateway-worker node [cni    1/1     Running   0          149m   10.0.0.87   cilium-egress-gateway-worker   <none>           <none>]
and 
the Egress node is: cilium-egress-gateway-worker3 
kubectl taint nodes $(kubectl get nodes -o name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl taint node cilium-egress-gateway-worker3 egress-gw:NoSchedule
kubectl label nodes cilium-egress-gateway-worker3 egress-gw=true

so the flow should be triggered from: test_pod(cni)10.0.0.87 via cilium-egress-gateway-worker to cilium-egress-gateway-worker3 and then reach at target instance(ext_client)
[root@wluo cilium-External-Networking]$ dip
NAME                                  STATUS   ROLES           AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION 
cilium-egress-gateway-control-plane   Ready    control-plane   4h54m   v1.27.3   172.18.0.5    <none>        Debian GNU/Linux 11 (bullseye)   6.5.0-25-generic   
cilium-egress-gateway-worker          Ready    <none>          4h54m   v1.27.3   172.18.0.2    <none>        Debian GNU/Linux 11 (bullseye)   6.5.0-25-generic
cilium-egress-gateway-worker3         Ready    <none>          4h54m   v1.27.3   172.18.0.3    <none>        Debian GNU/Linux 11 (bullseye)   6.5.0-25-generic
[root@wluo cilium-External-Networking]$ 

[root@wluo cilium-External-Networking]$ k -negress-access get pods -owide 
NAME   READY   STATUS    RESTARTS   AGE    IP          NODE                           NOMINATED NODE   READINESS GATES
cni    1/1     Running   0          155m   10.0.0.87   cilium-egress-gateway-worker   <none>           <none>

[root@wluo cilium-External-Networking]$ k -negress-noaccess get pods -owide 
NAME   READY   STATUS    RESTARTS   AGE     IP         NODE                           NOMINATED NODE   READINESS GATES
cni    1/1     Running   0          156m    10.0.0.42  cilium-egress-gateway-worker   <none>           <none>


1. test_pod(cni) to the self-host(veth pair logical)
2. self-host to Egress-Gateway(HOST)[VxLAN]
Frame 175: 124 bytes on wire (992 bits), 124 bytes captured (992 bits)
Ethernet II, Src: KinD_K8S_12:00:02 (02:42:ac:12:00:02), Dst: KinD_K8S_12:00:03 (02:42:ac:12:00:03)
Internet Protocol Version 4, Src: 172.18.0.2, Dst: 172.18.0.3 [self-host to Egress-Gateway host]
User Datagram Protocol, Src Port: 51537, Dst Port: 8472
Virtual eXtensible Local Area Network
Ethernet II, Src: 16:da:27:37:8f:3a (16:da:27:37:8f:3a), Dst: f2:cb:3e:d1:c0:1b (f2:cb:3e:d1:c0:1b)
Internet Protocol Version 4, Src: 10.0.0.87, Dst: 11.1.8.10 [orig packet from: 10.0.0.87 to 11.1.8.10]
Transmission Control Protocol, Src Port: 53182, Dst Port: 80, Seq: 0, Len: 0
3. and then the Egress-Gateway recv the packet and des-encaps the pcaket.
4. 1	2024-03-20 15:17:45.044472	11.1.5.13	11.1.8.10	TCP	74	80	49734	0	49734 → 80 [SYN] Seq=0 Win=64860 Len=0 MSS=1410 SACK_PERM TSval=3490803090 TSecr=0 WS=128
but the Egress-Gateway replase the src_ip_address with the eth9's[11.1.5.13]{SNAT}
5. Based on the routing table, and sent to the gw:11.1.5.1.

EOF

