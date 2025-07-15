#!/bin/bash

CPU_STAT_FILE="/sys/fs/cgroup/cpu.stat"

# 设置默认采样间隔为 5 秒，也可以通过参数传入
INTERVAL=${1:-5}

echo "Monitoring CPU usage every $INTERVAL seconds..."

while true; do
    # 获取第一次的 usage_usec 值
    first_value=$(grep "usage_usec" "$CPU_STAT_FILE" | awk '{print $2}')

    # 等待 INTERVAL 秒
    sleep "$INTERVAL"

    # 获取第二次的 usage_usec 值
    second_value=$(grep "usage_usec" "$CPU_STAT_FILE" | awk '{print $2}')

    # 计算差值（单位：微秒）
    difference=$((second_value - first_value))

    # 计算平均 CPU 使用率（基于 INTERVAL 秒的时间窗口）
    # 百分比 = (使用时间 / 总可用时间) * 100
    # 总可用时间 = INTERVAL 秒 = INTERVAL * 1,000,000 微秒
    cpu_usage=$(echo "scale=2; ($difference / (1000000 * $INTERVAL)) * 100" | bc)

    # 格式化输出，保留两位小数
    cpu_usage=$(printf "%.2f" "$cpu_usage")

    # 打印结果
    echo "#############################################################"
    echo "CPU Usage: $cpu_usage%"
done
