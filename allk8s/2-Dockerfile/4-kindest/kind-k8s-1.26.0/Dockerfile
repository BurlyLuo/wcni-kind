FROM kindest/node:v1.26.0
COPY ping calicoctl cilium /usr/bin/
COPY bridge macvlan ipvlan static bandwidth bond dhcp firewall host-device sbr tuning vlan /opt/cni/bin/
RUN apt-get -y update >/dev/null && apt-get -y install net-tools tcpdump lrzsz >/dev/null 2>&1
