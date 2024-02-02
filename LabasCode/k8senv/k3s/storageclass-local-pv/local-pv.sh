#!/bin/bash
START=1
END=$2
partition=$1

install ()
{
findmnt | grep  "\[" > /tmp/mountbind.txt

for (( i=$START; i<=$END; i++ )); do
  sudo mkdir -p /$partition/$partition-vol${i} /mnt/disks/$partition-vol${i}
if [ `grep $partition-vol${i} /tmp/mountbind.txt | wc -l` -lt 1 ]
then
  sudo mount --bind /$partition/$partition-vol${i} /mnt/disks/$partition-vol${i}
fi
done


for (( i=$START; i<=$END; i++ )); do
if [ `grep $partition-vol${i} /etc/fstab | wc -l` -lt 1 ]
then
  echo /$partition/$partition-vol${i} /mnt/disks/$partition-vol${i} none bind 0 0 | sudo tee -a /etc/fstab
fi
done
}

if [ $# -ne 2 ]; then
    echo "Usage: $0 <partition dirname > <# pv needed>"
    echo "Example : $0 data 4"
else
install
#findmnt | grep  "\[" 
fi
