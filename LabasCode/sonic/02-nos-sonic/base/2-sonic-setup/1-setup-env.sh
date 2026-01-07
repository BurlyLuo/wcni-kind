#!/bin/bash
brctl addbr mgtbr0
brctl addbr vmbr0

# 1. sonic1 node
virsh define sonic1/sonic1.xml
virsh start sonic1-vs

# 2. sonic2 node
virsh define sonic2/sonic2.xml
virsh start sonic2-vs

# 3. sonic3 node
virsh define sonic3/sonic3.xml
virsh start sonic3-vs

# 4. load configuration into sonic1/2/3
save configuration content to /etc/sonic/config_db.json

admin/YourPaSsWoRd

telnet localhost 7000
telnet localhost 7001
telnet localhost 7002

sudo config reload

show interfaces status

