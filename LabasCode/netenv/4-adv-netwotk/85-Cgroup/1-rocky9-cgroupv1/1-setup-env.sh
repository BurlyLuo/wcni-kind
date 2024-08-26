1. node version kernel version k8s version:
# [root@rocky92 ~]# k get nodes -owide 
NAME      STATUS   ROLES           AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE                      KERNEL-VERSION                 CONTAINER-RUNTIME
rocky92   Ready    control-plane   14d   v1.28.2   192.168.2.55   <none>        Rocky Linux 9.2 (Blue Onyx)   5.14.0-284.11.1.el9_2.x86_64   docker://27.1.1
[root@rocky92 ~]# 

2. cgroup v1
[[root@rocky92 ~]# cat /etc/default/grub 
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
#[grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0 systemd.legacy_systemd_cgroup_controller"]
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=0 console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M default_hugepagesz=1G hugepagesz=1G hugepages=4 iommu=pt intel_iommu=on systemd.unified_cgroup_hierarchy=0 systemd.legacy_systemd_cgroup_controller"
GRUB_DISABLE_RECOVERY="true"
GRUB_ENABLE_BLSCFG=true
[root@rocky92 ~]# ]
[root@rocky92 ~]# mount -l | grep cgroup
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,size=4096k,nr_inodes=1024,mode=755,inode64)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/misc type cgroup (rw,nosuid,nodev,noexec,relatime,misc)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/rdma type cgroup (rw,nosuid,nodev,noexec,relatime,rdma)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
[root@rocky92 ~]# 

3. dedicate cpu pod:
apiVersion: v1
kind: Pod
metadata:
  name: cpu-pin
spec:
  containers:
  - name: cpu-pin
    image: 192.168.2.100:5000/centos:8
    command: [ "/sbin/init"  ]
    imagePullPolicy: IfNotPresent
    resources:
      requests:
        memory: "200Mi"
        cpu: "2"
        hugepages-1Gi: 1Gi
        intel.com/sriov_vppdpdk5: "1"
      limits:
        memory: "200Mi"
        cpu: "2"
        hugepages-1Gi: 1Gi
        intel.com/sriov_vppdpdk5: "1"

4. CPU and Memory Calc:
1. cgroup 计算
[root@cpu-pin ~]# cat /sys/fs/cgroup/cpu/cpuacct.usage;sleep 5;cat /sys/fs/cgroup/cpu/cpuacct.usage
556644463071
558521617543
[root@cpu-pin ~]# 
[root@cpu-pin ~]# taskset -cp 1 
pid 1's current affinity list: 4,5
[root@cpu-pin ~]# 

4.1:初始值
第一次读取 /sys/fs/cgroup/cpu/cpuacct.usage: 556644463071 纳秒
第二次读取: 558521617543 纳秒

4.2:计算差值
差值 = 558521617543 - 556644463071 = 1873152472 纳秒
转换为秒
1873152472 纳秒 = 1873152472 / 1,000,000,000 = 1.873152472 秒
总时间
在这个例子中，您让系统休眠了 5 秒，所以总时间是 5 秒。

4.3:CPU 使用率（针对两个核心）
由于这段时间内使用的是两个 CPU 核心，因此我们可以计算整体 CPU 使用率：

CPU 使用率 (%) = (实际 CPU 时间 / 总时间) * 100
CPU 使用率 (%) = (1873152472 / (5 * 1,000,000,000)) * 100
CPU 使用率 (%) = (1873152472 / 5000000000) * 100 ≈ 37.46%

4.4. 每个核心的平均利用率
因为这是两个核心的总使用情况，可以求出每个核心的平均利用率：

每个核心的 CPU 使用率 = 总体使用率 / 2
每个核心的 CPU 使用率 ≈ 37.46% / 2 = 18.73%

TOP结果：
%Cpu4  :  0.3 us,  0.7 sy,  0.0 ni, 99.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu5  : 37.2 us,  1.7 sy,  0.0 ni, 61.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

AVG_TOP=(37.2+0.3)/2=18.75

所以：
AVG_CGROUP_V1=18.73%
AVG_TOP=18.75%

# Memory:
我们提供一个占用100MiB的C代码段：
# cat mem.c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // 定义需要分配的内存大小（100 MiB）
    size_t size = 100 * 1024 * 1024; // 100 MiB
    char *buffer = (char *)malloc(size);

    if (buffer == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1; // 返回错误码
    }

    // 初始化内存以确保它被使用
    for (size_t i = 0; i < size; i++) {
        buffer[i] = 0; // 使用内存
    }

    printf("Allocated and initialized 100 MiB of memory. Press Enter to release...\n");
    getchar(); // 等待用户输入

    free(buffer); // 释放内存
    printf("Memory released successfully.\n");

    return 0; // 返回成功码
}

gcc mem.c -o mem
chmod +x mem
./mem
[root@cpu-pin ~]# ./mem
Allocated and initialized 100 MiB of memory. Press Enter to release...

而我设置的Memory是：
# k get pods cpu-pin -o yaml 
    resources:
      limits:
        cpu: "2"
        hugepages-1Gi: 1Gi
        intel.com/sriov_vppdpdk5: "1"
        memory: 200Mi
      requests:
        cpu: "2"
        hugepages-1Gi: 1Gi
        intel.com/sriov_vppdpdk5: "1"
        memory: 200Mi
那按道理我们计算出来的Mem的使用率应该是50%左右。
rss from memory.stat
total_memory from memory.limit_in_bytes
[root@cpu-pin ~]# cat /sys/fs/cgroup/memory/memory.stat | grep -w rss
rss 107655168
[root@cpu-pin ~]# 
[root@cpu-pin ~]# cat /sys/fs/cgroup/memory/memory.limit_in_bytes 
209715200
[root@cpu-pin ~]# 

AVG_MEM使用率: 107655168/209715200*100% = 51.333%

