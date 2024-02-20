https://github.com/cilium/cilium/releases/tag/v1.15.0

1. kind image
docker pull burlyluo/kindest:v1.27.3

2. kind version
kind v0.20.0 go1.20.4 linux/amd64

3. docker version
Client:
 Context:    default
 Debug Mode: false

Server:
 Containers: 2
  Running: 2
  Paused: 0
  Stopped: 0
 Images: 17
 Server Version: 23.0.1
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Using metacopy: false
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc io.containerd.runc.v2
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 2456e983eb9e37e47538f59ea18f2043c9a73640
 runc version: v1.1.4-0-g5fd4c4d
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.5.0-18-generic
 Operating System: Ubuntu 22.04.3 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 12
 Total Memory: 21.46GiB
 Name: wluo
 ID: da8e8605-be1f-491d-9002-0e6fb6731131
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Username: burlyluo
 Registry: https://index.docker.io/v1/
 Experimental: false
 Insecure Registries:
  192.168.2.100:5000
  127.0.0.0/8
 Registry Mirrors:
  https://geaiu7n3.mirror.aliyuncs.com/
 Live Restore Enabled: false

4. kubectl version
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.4", GitCommit:"e6c093d87ea4cbb530a7b2ae91e54c0842d8308a", GitTreeState:"clean", BuildDate:"2022-02-16T12:38:05Z", GoVersion:"go1.17.7", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.3", GitCommit:"25b4e43193bcda6c7328a6d147b1fb73a33f1598", GitTreeState:"clean", BuildDate:"2023-06-15T00:36:28Z", GoVersion:"go1.20.5", Compiler:"gc", Platform:"linux/amd64"}
WARNING: version difference between client (1.23) and server (1.27) exceeds the supported minor version skew of +/-1

5. lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Release:        22.04
Codename:       jammy

6. uname -a
Linux wluo 6.5.0-18-generic #18~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Wed Feb  7 11:40:03 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

