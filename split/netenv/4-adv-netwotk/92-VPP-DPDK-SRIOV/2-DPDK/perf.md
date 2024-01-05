[root@atcf-cap-mwp-worker8 mavenir]# mpstat -u -P  6,8,10 1
Linux 3.10.0-1160.88.1.el7.x86_64 (atcf-cap-mwp-worker8) 	01/05/24 	_x86_64_	(104 CPU)

08:20:23     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
08:20:24       6   87.88    0.00    0.00    0.00    0.00   12.12    0.00    0.00    0.00    0.00
08:20:24       8  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
08:20:24      10  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
08:20:25       6   88.00    0.00    0.00    0.00    0.00   12.00    0.00    0.00    0.00    0.00
08:20:25       8  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
08:20:25      10  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
08:20:26       6   89.00    0.00    0.00    0.00    0.00   11.00    0.00    0.00    0.00    0.00
08:20:26       8  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
08:20:26      10  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
^C
Average:       6   88.29    0.00    0.00    0.00    0.00   11.71    0.00    0.00    0.00    0.00
Average:       8  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
Average:      10  100.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00
[root@atcf-cap-mwp-worker8 mavenir]# 


perf top -C 8
Samples: 55K of event 'cycles:ppp', 4000 Hz, Event count (approx.): 28779366658 lost: 0/0 drop: 0/0                                                                      
Overhead  Shared Object         Symbol                                                                                                                                   
  22.13%  dpdk_plugin.so        [.] dpdk_buffer_free_avx512
  15.22%  libvlib.so.20.09      [.] 0x00000000000893ef
   4.74%  vpp                   [.] 0x0000000000981496
   2.95%  libvlib.so.20.09      [.] 0x00000000000893fc
   2.08%  libvlib.so.20.09      [.] 0x0000000000089a72
   2.00%  libvlib.so.20.09      [.] 0x00000000000897f5
   1.66%  libvlib.so.20.09      [.] 0x0000000000089a68
   1.44%  libvlib.so.20.09      [.] 0x0000000000089497
   1.24%  vpp                   [.] 0x00000000009814a0
   1.18%  vpp                   [.] 0x000000000098146f
   1.13%  libvlib.so.20.09      [.] 0x0000000000089cb7
   0.93%  vpp                   [.] 0x0000000000981487
   0.91%  libvlib.so.20.09      [.] 0x0000000000089ead
   0.87%  libvlib.so.20.09      [.] 0x0000000000089f57
   0.78%  libvlib.so.20.09      [.] 0x0000000000089fb2
   0.72%  vpp                   [.] 0x000000000098611e
   0.70%  vpp                   [.] 0x0000000000986136
   0.70%  rtp_plugin.so         [.] fp_rtpfw_rtp_udp_ip6_input
   0.68%  rtp_plugin.so         [.] fp_rtpfw_rtp_ingress
   0.68%  vpp                   [.] 0x0000000000986117
   0.67%  vpp                   [.] 0x0000000000981464
   0.66%  vpp                   [.] 0x0000000000981455
   0.66%  vpp                   [.] 0x000000000098145c
   0.66%  vpp                   [.] 0x0000000000986145
   0.61%  vpp                   [.] 0x0000000000981b8a
   0.59%  vpp                   [.] 0x000000000098615b
   0.58%  libvlib.so.20.09      [.] 0x0000000000089d47
   0.58%  vpp                   [.] 0x00000000009814b1
   0.58%  vpp                   [.] 0x0000000000981b83
   0.57%  vpp                   [.] 0x0000000000986154
   0.54%  vpp                   [.] 0x00000000009814bf
   0.49%  vpp                   [.] 0x0000000000981b7a
   0.47%  libvlib.so.20.09      [.] 0x0000000000089f87
   0.47%  rtp_plugin.so         [.] FpnQosInput6
   0.46%  rtp_plugin.so         [.] sessionEntryGetRtp6
   0.43%  rtp_plugin.so         [.] 0x00000000001cdf52
   0.43%  libvlib.so.20.09      [.] 0x0000000000089cba
   0.41%  libvlib.so.20.09      [.] 0x0000000000089eb4
   0.41%  rtp_plugin.so         [.] fp_rtpfw_convert_rfc4867_to_evs
   0.41%  vpp                   [.] 0x000000000099bba1
[root@atcf-cap-mwp-worker8 mavenir]# 

perf top -C 6
Samples: 63K of event 'cycles:ppp', 4000 Hz, Event count (approx.): 31021193975 lost: 0/0 drop: 0/0                                                                      
Overhead  Shared Object         Symbol                                                                                                                                   
  18.81%  dpdk_plugin.so        [.] dpdk_buffer_free_avx512
  13.10%  libvlib.so.20.09      [.] 0x00000000000893ef
   3.01%  vpp                   [.] 0x0000000000981496
   2.51%  libvlib.so.20.09      [.] 0x00000000000893fc
   1.82%  libvlib.so.20.09      [.] 0x0000000000089a72
   1.65%  libvlib.so.20.09      [.] 0x00000000000897f5
   1.40%  libvlib.so.20.09      [.] 0x0000000000089a68
   1.16%  libvlib.so.20.09      [.] 0x0000000000089497
   1.00%  libvlib.so.20.09      [.] 0x0000000000089cb7
   0.97%  vpp                   [.] 0x00000000009814a0
   0.86%  libvlib.so.20.09      [.] 0x0000000000089ead
   0.85%  libvlib.so.20.09      [.] 0x0000000000089f57
   0.73%  rtp_plugin.so         [.] fp_rtpfw_rtp_udp_ip6_input
   0.71%  vpp                   [.] 0x00000000009814bf
   0.66%  libvlib.so.20.09      [.] 0x0000000000089fb2
   0.62%  vpp                   [.] 0x000000000098146f
   0.58%  rtp_plugin.so         [.] fp_rtpfw_rtp_ingress
   0.56%  [kernel]              [k] i40e_napi_poll
   0.54%  [kernel]              [k] retint_userspace_restore_args
   0.54%  rtp_plugin.so         [.] FpnQosInput6
   0.54%  vpp                   [.] 0x000000000098145c
   0.54%  vpp                   [.] 0x0000000000981455
   0.53%  vpp                   [.] 0x0000000000986145
   0.53%  vpp                   [.] 0x0000000000981464
   0.52%  vpp                   [.] 0x0000000000986136
   0.51%  vpp                   [.] 0x000000000098611e
   0.51%  vpp                   [.] 0x0000000000981487
   0.50%  vpp                   [.] 0x0000000000986117
   0.48%  rtp_plugin.so         [.] 0x00000000001c9138
   0.46%  [kernel]              [k] __nf_conntrack_find_get
   0.46%  rtp_plugin.so         [.] 0x00000000001cdf52
   0.45%  libvlib.so.20.09      [.] 0x0000000000089d47
   0.45%  rtp_plugin.so         [.] 0x0000000000176d90
   0.45%  rtp_plugin.so         [.] sessionEntryGetRtcp6
   0.40%  vpp                   [.] 0x00000000009814b1
   0.40%  libvlib.so.20.09      [.] 0x0000000000089f87
   0.40%  rtp_plugin.so         [.] sessionEntryGetRtp6
   0.40%  vpp                   [.] 0x0000000000986154
   0.39%  vpp                   [.] 0x0000000000981b83
   0.39%  vpp                   [.] 0x000000000099bba1
[root@atcf-cap-mwp-worker8 mavenir]# 
perf top -C 10
Samples: 39K of event 'cycles:ppp', 4000 Hz, Event count (approx.): 22999589657 lost: 0/0 drop: 0/0                                                                      
Overhead  Shared Object         Symbol                                                                                                                                   
  22.71%  dpdk_plugin.so        [.] dpdk_buffer_free_avx512
  15.72%  libvlib.so.20.09      [.] 0x00000000000893ef
   3.97%  vpp                   [.] 0x0000000000981496
   3.14%  libvlib.so.20.09      [.] 0x00000000000893fc
   2.24%  libvlib.so.20.09      [.] 0x0000000000089a72
   1.98%  libvlib.so.20.09      [.] 0x00000000000897f5
   1.51%  libvlib.so.20.09      [.] 0x0000000000089497
   1.49%  libvlib.so.20.09      [.] 0x0000000000089a68
   1.20%  vpp                   [.] 0x00000000009814a0
   1.20%  libvlib.so.20.09      [.] 0x0000000000089cb7
   1.06%  libvlib.so.20.09      [.] 0x0000000000089ead
   0.96%  libvlib.so.20.09      [.] 0x0000000000089f57
   0.77%  vpp                   [.] 0x0000000000986145
   0.75%  vpp                   [.] 0x000000000098146f
   0.74%  libvlib.so.20.09      [.] 0x0000000000089fb2
   0.71%  vpp                   [.] 0x00000000009814bf
   0.70%  vpp                   [.] 0x0000000000981464
   0.69%  vpp                   [.] 0x0000000000986136
   0.68%  vpp                   [.] 0x0000000000986117
   0.65%  vpp                   [.] 0x000000000098145c
   0.65%  vpp                   [.] 0x000000000098611e
   0.64%  libvlib.so.20.09      [.] 0x0000000000089d47
   0.63%  vpp                   [.] 0x0000000000981487
   0.63%  vpp                   [.] 0x0000000000981455
   0.60%  rtp_plugin.so         [.] fp_rtpfw_rtp_udp_ip6_input
   0.57%  rtp_plugin.so         [.] fp_rtpfw_rtp_ingress
   0.55%  vpp                   [.] 0x00000000009814b1
   0.52%  rtp_plugin.so         [.] FpnQosInput6
   0.51%  vpp                   [.] 0x0000000000986154
   0.49%  vpp                   [.] 0x0000000000981b83
   0.49%  vpp                   [.] 0x000000000098615b
   0.48%  vpp                   [.] 0x0000000000981b8a
   0.48%  vpp                   [.] 0x0000000000981b7a
   0.47%  vpp                   [.] 0x00000000009814ac
   0.46%  libvlib.so.20.09      [.] 0x0000000000089eb4
   0.45%  libvlib.so.20.09      [.] 0x0000000000089f87
   0.38%  libvlib.so.20.09      [.] 0x0000000000089f93
   0.37%  libvlib.so.20.09      [.] 0x0000000000089cba
   0.37%  libmdpmemif.so        [.] _fini
   0.37%  rtp_plugin.so         [.] sessionEntryGetRtcp6
[root@atcf-cap-mwp-worker8 mavenir]# 
