FROM kindest/node:v1.23.4
COPY ping calicoctl cilium /usr/bin/
COPY bridge macvlan ipvlan static bandwidth bond dhcp firewall host-device sbr tuning vlan /opt/cni/bin/
RUN sed -i -e 's/jp.archive.ubuntu.com\|archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list  && apt-get -y update >/dev/null && apt-get -y install net-tools tcpdump lrzsz >/dev/null 2>&1
