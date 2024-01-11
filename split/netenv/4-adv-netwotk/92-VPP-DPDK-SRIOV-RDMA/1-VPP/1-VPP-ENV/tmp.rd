[root@localhost ~]# yum list vpp* && yum install -y vpp vpp-api-lua vpp-api-python vpp-api-python3 vpp-debuginfo vpp-devel vpp-ext-deps vpp-lib vpp-plugins vpp-selinux-policy
Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Loading mirror speeds from cached hostfile
 * base: mirrors.nju.edu.cn
 * epel: mirror.nju.edu.cn
 * extras: mirrors.nju.edu.cn
 * updates: mirrors.nju.edu.cn
Installed Packages
vpp.x86_64                                                                          20.01-release                                                           @fdio_release
vpp-debuginfo.x86_64                                                                20.01-release                                                           @fdio_release
vpp-devel.x86_64                                                                    20.01-release                                                           @fdio_release
vpp-ext-deps.x86_64                                                                 19.04-16                                                                @fdio_release
vpp-lib.x86_64                                                                      20.01-release                                                           @fdio_release
vpp-selinux-policy.x86_64                                                           20.01-release                                                           @fdio_release
Available Packages
vpp-api-java.x86_64                                                                 19.04-release                                                           fdio_release 
vpp-api-lua.x86_64                                                                  20.01-release                                                           fdio_release 
vpp-api-python.x86_64                                                               20.01-release                                                           fdio_release 
vpp-api-python3.x86_64                                                              20.01-release                                                           fdio_release 
vpp-plugins.x86_64                                                                  20.01-release                                                           fdio_release 
Loaded plugins: fastestmirror, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Loading mirror speeds from cached hostfile
 * base: mirrors.nju.edu.cn
 * epel: mirror.nju.edu.cn
 * extras: mirrors.nju.edu.cn
 * updates: mirrors.nju.edu.cn
fdio_release/x86_64/signature                                                                                                                     |  833 B  00:00:00     
fdio_release/x86_64/signature                                                                                                                     | 1.8 kB  00:00:00 !!! 
Package vpp-20.01-release.x86_64 already installed and latest version
Package vpp-debuginfo-20.01-release.x86_64 already installed and latest version
Package vpp-devel-20.01-release.x86_64 already installed and latest version
Package vpp-ext-deps-19.04-16.x86_64 already installed and latest version
Package vpp-lib-20.01-release.x86_64 already installed and latest version
Package vpp-selinux-policy-20.01-release.x86_64 already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package vpp-api-lua.x86_64 0:20.01-release will be installed
---> Package vpp-api-python.x86_64 0:20.01-release will be installed
---> Package vpp-api-python3.x86_64 0:20.01-release will be installed
---> Package vpp-plugins.x86_64 0:20.01-release will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=========================================================================================================================================================================
 Package                                     Arch                               Version                                   Repository                                Size
=========================================================================================================================================================================
Installing:
 vpp-api-lua                                 x86_64                             20.01-release                             fdio_release                              27 k
 vpp-api-python                              x86_64                             20.01-release                             fdio_release                              59 k
 vpp-api-python3                             x86_64                             20.01-release                             fdio_release                              60 k
 vpp-plugins                                 x86_64                             20.01-release                             fdio_release                             6.6 M

Transaction Summary
=========================================================================================================================================================================
Install  4 Packages

Total download size: 6.7 M
Installed size: 50 M
Downloading packages:
(1/4): vpp-api-lua-20.01-release.x86_64.rpm                                                                                                       |  27 kB  00:00:01     
(2/4): vpp-api-python-20.01-release.x86_64.rpm                                                                                                    |  59 kB  00:00:01     
(3/4): vpp-api-python3-20.01-release.x86_64.rpm                                                                                                   |  60 kB  00:00:00     
(4/4): vpp-plugins-20.01-release.x86_64.rpm                                                                                                       | 6.6 MB  00:00:01     
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                    1.9 MB/s | 6.7 MB  00:00:03     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : vpp-plugins-20.01-release.x86_64                                                                                                                      1/4 
  Installing : vpp-api-lua-20.01-release.x86_64                                                                                                                      2/4 
  Installing : vpp-api-python3-20.01-release.x86_64                                                                                                                  3/4 
  Installing : vpp-api-python-20.01-release.x86_64                                                                                                                   4/4 
  Verifying  : vpp-api-python-20.01-release.x86_64                                                                                                                   1/4 
  Verifying  : vpp-api-python3-20.01-release.x86_64                                                                                                                  2/4 
  Verifying  : vpp-api-lua-20.01-release.x86_64                                                                                                                      3/4 
  Verifying  : vpp-plugins-20.01-release.x86_64                                                                                                                      4/4 

Installed:
  vpp-api-lua.x86_64 0:20.01-release      vpp-api-python.x86_64 0:20.01-release      vpp-api-python3.x86_64 0:20.01-release      vpp-plugins.x86_64 0:20.01-release     

Complete!
[root@localhost ~]# systemctl status vpp


[root@localhost ~]# systemctl status vpp
● vpp.service - Vector Packet Processing Process
   Loaded: loaded (/usr/lib/systemd/system/vpp.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2024-01-05 00:48:47 UTC; 1s ago
  Process: 1764 ExecStartPre=/sbin/modprobe uio_pci_generic (code=exited, status=0/SUCCESS)
  Process: 1762 ExecStartPre=/bin/rm -f /dev/shm/db /dev/shm/global_vm /dev/shm/vpe-api (code=exited, status=0/SUCCESS)
 Main PID: 1767 (vpp_main)
    Tasks: 3
   Memory: 69.8M
   CGroup: /system.slice/vpp.service
           └─1767 /usr/bin/vpp -c /etc/vpp/startup.conf

Jan 05 00:48:48 localhost vnet[1767]: load_one_vat_plugin:67: Loaded plugin: nsim_test_plugin.so
Jan 05 00:48:48 localhost vnet[1767]: vat_plugin_register: oddbuf plugin not loaded...
Jan 05 00:48:48 localhost vnet[1767]: vat_plugin_register: pppoe plugin not loaded...
Jan 05 00:48:48 localhost vnet[1767]: vat_plugin_register: rdma plugin not loaded...
Jan 05 00:48:48 localhost vnet[1767]: load_one_vat_plugin:67: Loaded plugin: stn_test_plugin.so
Jan 05 00:48:48 localhost vnet[1767]: load_one_vat_plugin:67: Loaded plugin: tlsopenssl_test_plugin.so
Jan 05 00:48:48 localhost vnet[1767]: load_one_vat_plugin:67: Loaded plugin: vmxnet3_test_plugin.so
Jan 05 00:48:48 localhost vnet[1767]: dpdk_ipsec_process:1014: not enough DPDK crypto resources, default to OpenSSL
Jan 05 00:48:48 localhost vnet[1767]: dpdk: unsupported rx offloads requested on port 0: scatter
Jan 05 00:48:48 localhost vnet[1767]: dpdk: unsupported rx offloads requested on port 1: scatter
