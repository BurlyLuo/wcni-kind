#/bin/bash
set -x 
cat hostname.txt | while read hostname ipaddr passwd;do sshpass -p $passwd ssh-copy-id $ipaddr;done
