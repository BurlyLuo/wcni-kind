# 初始化一个空的变量来存储 CPU IDs
cpu_ids=""

for cpu in $(taskset -cp 1 | awk -F ":" '{print $NF}' | awk '$1=$1' | tr "," '\n'); do
    if [[  $cpu == *-* ]]; then
        IFS="-" read -r start_cpu end_cpu <<< "$cpu"
        echo "start_cpu: $start_cpu, end_cpu: $end_cpu"
        for ((row_cpu=start_cpu; row_cpu<=end_cpu; row_cpu++)); do
            # 将 CPU ID 添加到变量中
            cpu_ids+="$row_cpu "
            echo "Host_Cpu_id: $row_cpu"
        done
    else
        cpu_ids+="$cpu "
        echo "Host_Cpu_id: $cpu"
    fi
done

# 使用单次调用 top 获取所有 CPU 的使用情况
echo "Fetching CPU usage for: $cpu_ids"
top_output=$(top -bn 1)

# 输出每个指定 CPU 的使用情况
for cpu in $cpu_ids; do
    echo "$top_output" | grep -E "Cpu${cpu}:" || echo "No data found for Cpu${cpu}."
done

