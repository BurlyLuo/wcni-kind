#!/usr/bin/env bash

STARTUP_CONFIG=${STARTUP_CONFIG:="/etc/vpp/startup.conf"}
CLAB_VPP_FILE=${CLAB_VPP_FILE:=/etc/vpp/clab.vpp}
VPPCFG_VPP_FILE=${VPPCFG_VPP_FILE:=/etc/vpp/vppcfg.vpp}
NETNS=${NETNS:="dataplane"}
BIRD_ENABLED=${BIRD_ENABLED:="true"}
FRR_ENABLED=${FRR_ENABLED:="false"}

echo "Creating dataplane namespace"
/usr/bin/mkdir -p /etc/netns/$NETNS
/usr/bin/touch /etc/netns/$NETNS/resolv.conf
/usr/sbin/ip netns add $NETNS

echo "Starting SSH, with credentials root:vpp"
sed -i -e 's,^#PermitRootLogin prohibit-password,PermitRootLogin yes,' /etc/ssh/sshd_config
sed -i -e 's,^root:.*,root:$y$j9T$kG8pyZEVmwLXEtXekQCRK.$9iJxq/bEx5buni1hrC8VmvkDHRy7ZMsw9wYvwrzexID:20211::::::,' /etc/shadow
/etc/init.d/ssh start

if [ "$BIRD_ENABLED" == "true" ]; then
  echo "Starting Bird in $NETNS"
  mkdir -p /run/bird /var/log/bird
  chown bird:bird /var/log/bird
  ROUTERID=$(ip -br a show eth0 | awk '{ print $3 }' | cut -f1 -d/)
  sed -i -e "s,.*router id .*,router id $ROUTERID; # Set by container-init.sh," /etc/bird/bird.conf
  /usr/bin/nsenter --net=/var/run/netns/$NETNS /usr/sbin/bird -u bird -g bird
fi

if [ "$FRR_ENABLED" == "true" ]; then
  echo "Starting FRRouting in $NETNS"
  ROUTERID=$(ip -br a show eth0 | awk '{ print $3 }' | cut -f1 -d/)
  sed -i -e "s,^ip router-id .*,ip router-id $ROUTERID," /etc/frr/frr.conf
  /etc/init.d/frr start
fi

echo "Generating $CLAB_VPP_FILE"
: > $CLAB_VPP_FILE
MTU=9216
for IFNAME in $(ip -br link show type veth | cut -f1 -d@ | grep -v '^eth0$' | sort); do
  MAC=$(ip -br link show dev $IFNAME | awk '{ print $3 }')
  echo " * $IFNAME hw-addr $MAC mtu $MTU"
  ip link set $IFNAME up mtu $MTU
  cat << EOF >> $CLAB_VPP_FILE
create host-interface name $IFNAME hw-addr $MAC
set interface name host-$IFNAME $IFNAME
set interface mtu $MTU $IFNAME
set interface state $IFNAME up

EOF
done

echo "Generating $VPPCFG_VPP_FILE"
: > $VPPCFG_VPP_FILE
if [ -r /etc/vpp/vppcfg.yaml ]; then
  vppcfg plan --novpp -c /etc/vpp/vppcfg.yaml -o $VPPCFG_VPP_FILE
fi

echo "Starting VPP"
exec /usr/bin/vpp -c $STARTUP_CONFIG
