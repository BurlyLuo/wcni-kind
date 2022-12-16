
$ 1.docker in docker:
docker run --name=dind -td --privileged=true 192.168.2.100:5000/centos:7 /sbin/init

$ 2.docker pid mapping:
root@wluo:~# docker exec -it dind bash 
[root@a68e8cbc66b3 /]# ps -ef 
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 06:54 ?        00:00:00 /sbin/init
root          17       1  0 06:54 ?        00:00:00 /usr/lib/systemd/systemd-journald
root          30       1  0 06:54 ?        00:00:00 /usr/lib/systemd/systemd-udevd
root          70       1  0 06:54 ?        00:00:00 /usr/lib/systemd/systemd-logind
dbus          71       1  0 06:54 ?        00:00:00 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
root          73       1  0 06:54 tty1     00:00:00 /sbin/agetty --noclear tty1 linux
root         111       0  0 13:38 pts/1    00:00:00 bash
root         125     111  0 13:38 pts/1    00:00:00 ps -ef

root@wluo:~# docker top dind
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                7808                7786                0                   14:54               ?                   00:00:00            /sbin/init
root                7853                7808                0                   14:54               ?                   00:00:00            /usr/lib/systemd/systemd-journald
root                7866                7808                0                   14:54               ?                   00:00:00            /usr/lib/systemd/systemd-udevd
root                7909                7808                0                   14:54               ?                   00:00:00            /usr/lib/systemd/systemd-logind
81                  7910                7808                0                   14:54               ?                   00:00:00            /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
root                7912                7808                0                   14:54               tty1                00:00:00            /sbin/agetty --noclear tty1 linux
root@wluo:~# 

We can use docker top to get the mapping list.





