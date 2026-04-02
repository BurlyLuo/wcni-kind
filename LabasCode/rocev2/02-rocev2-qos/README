nv set qos roce enable on   
nv set qos roce mode lossless
nv set qos traffic-pool roce-lossless memory-percent 50
nv set qos mapping ROCE_MAP trust both
nv set qos mapping ROCE_MAP dscp 24 switch-priority 3
nv set qos mapping ROCE_MAP dscp 26 switch-priority 3
nv set qos egress-queue-mapping default-global switch-priority 3 traffic-class 3
nv set qos pfc ROCE_PFC_PROF switch-priority 3
nv set qos pfc ROCE_PFC_PROF tx enable
nv set qos pfc ROCE_PFC_PROF rx enable
nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 ecn enable
nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 min-threshold 150000
nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 max-threshold 300000
nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 probability 100

nv set interface swp12 link state up
nv set interface swp12 link mtu 9000
nv set interface swp12 qos mapping profile ROCE_MAP
nv set interface swp12 qos pfc profile ROCE_PFC_PROF
nv set interface swp12 qos congestion-control profile ROCE_ECN_PROF
nv config apply -y
nv config save -y
nv show qos roce
nv show qos mapping ROCE_MAP
nv show qos egress-queue-mapping default
nv show qos congestion-control ROCE_ECN_PROF
nv show interface swp12 qos
nv show qos pfc ROCE_PFC_PROF


# 开启roce的能力
nv set qos roce enable on 
# 开启roce的模式为无损模式
nv set qos roce mode lossless
# 设置给roce的buffer占总的buffer的50%
nv set qos traffic-pool roce-lossless memory-percent 50
# 设置处理基于pcp和dscp方式映射到队列的方式
nv set qos mapping ROCE_MAP trust both
# 配置dscp值是24/26的map到交换机的优先级3上去[24=011000{注意dscp只有6位，后2位是ECN的标志位}]
nv set qos mapping ROCE_MAP dscp 24 switch-priority 3
nv set qos mapping ROCE_MAP dscp 26 switch-priority 3

1. 报文进入 (DSCP=24)
      ↓
2. DSCP 映射
   nv set qos mapping ROCE_MAP dscp 24 switch-priority 3
   (DSCP 24 → switch-priority 3)
      ↓
3. 内部优先级到队列映射  ← 这条命令在这里
   nv set qos egress-queue-mapping default-global switch-priority 3 traffic-class 3
   (switch-priority 3 → traffic-class 3)
      ↓
4. 进入队列 3
      ↓
5. PFC/ECN 生效
   - PFC: 队列 3 启用 PAUSE 机制
   - ECN: 队列 3 启用拥塞标记
      ↓
6. 队列调度发出
nv set qos egress-queue-mapping default-global switch-priority 3 traffic-class 3

nv set qos pfc ROCE_PFC_PROF switch-priority 3
nv set qos pfc ROCE_PFC_PROF tx enable
nv set qos pfc ROCE_PFC_PROF rx enable

nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 ecn enable
nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 min-threshold 150000
nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 max-threshold 300000
nv set qos congestion-control ROCE_ECN_PROF traffic-class 3 probability 100

nv set interface swp12 link state up
nv set interface swp12 link mtu 9000
nv set interface swp12 qos mapping profile ROCE_MAP
nv set interface swp12 qos pfc profile ROCE_PFC_PROF
nv set interface swp12 qos congestion-control profile ROCE_ECN_PROF

nv config apply -y
nv config save -y

nv show qos roce
nv show qos mapping ROCE_MAP
nv show qos egress-queue-mapping default
nv show qos congestion-control ROCE_ECN_PROF
nv show interface swp12 qos
nv show qos pfc ROCE_PFC_PROF

