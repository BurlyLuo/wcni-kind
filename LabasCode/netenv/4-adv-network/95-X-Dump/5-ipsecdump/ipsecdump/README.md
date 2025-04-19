# ipsecdump

Dump incoming IPSec packets after they have been decrypted by the kernel

## usage

```
# ipsecdump -h
Usage of ipsecdump:
  -d string
    	IPSec tunnel destination IP
  -g int
    	NFLOG group to use (default 5050)
  -i string
    	incoming interface to listen on (default: any) (default "any")
  -m string
    	IPSec mode (tunnel or transport) (default "tunnel")
  -s string
    	IPSec tunnel source IP
  -t duration
    	how long to run the NFLOG dumping (default 10s)
```

## example

```
# ipsecdump -i eth0
20:15:16.661512 IP 198.51.100.146 > 203.0.113.222: ICMP echo request, id 3567, seq 1, length 31
20:15:21.661062 IP 198.51.100.146 > 203.0.113.222: ICMP echo request, id 3567, seq 1, length 31
20:15:26.661180 IP 198.51.100.146 > 203.0.113.222: ICMP echo request, id 3567, seq 1, length 31
20:15:31.661353 IP 198.51.100.146 > 203.0.113.222: ICMP echo request, id 3567, seq 1, length 31
...
```
