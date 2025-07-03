#1)Input arguments validation
if [[ $1 -eq "--help" ]] ; then
    echo "Usage: ./mxTop.sh out put instant cpu/average cpu and instant memory. 
	         if no parameter, he interval time is 3 seconds. sample nubmer is 10. 
                 if the first parameter is digital, it will set as interval time."
elif [[ $1 =~ ^[0-9]+$ ]]; then
    sleepInterval=$(echo $1)
else
    sleepInterval=3
fi

#2)Input arguments storing in local variables
#echo "sleepInterval=" $sleepInterval
#cpuCalcType=$(echo $2)
#echo "cpuCalculationType=" $cpuCalcType

#3)Get cgroup path corresponding to the v1 or v2
if [[ -v CPULIMIT ]]
then
    cpuLimit=$(echo "${CPULIMIT//[^0-9.]/}")
    #echo "cpuLimit=" $cpuLimit
else
    echo 'Please use this script only in containerized environment or set CPULIMIT in helm chart.'
    exit 0
fi

v1v2=$(stat -fc %T /sys/fs/cgroup/)
if [ $v1v2 = "tmpfs" ]; then
	v1v2flag=1
        echo "cgroup V1 system."
	cgroup=$(awk -F: '$2 == "cpu,cpuacct" { print $3 }' /proc/self/cgroup)
	if [ -z $cgroup ]; then
		cgroup=$(awk -F: '$2 == "cpuacct,cpu" { print $3 }' /proc/self/cgroup)
	fi
	#echo "cgroupv1 pod path=" $cgroup
	if [ ! -d "/sys/fs/cgroup/cpu/$cgroup/" ]; then
		cgroup=""
		#echo "Using generic cgroupv1 path /sys/fs/cgroup/cpu/"
	#else
		#echo "Using pod specific cgroupv1 path=/sys/fs/cgroup/cpu/$cgroup"
fi
else
	v1v2flag=2
        echo "cgroup V2 system."
	cgroup=$(awk -F: '$1 == "0" && $2 == "" { print $3 }' /proc/self/cgroup)
	#echo "cgroup=$cgroup"
fi


# Get have excluded path or not
excluded_cpu=$(curl -s -g -X GET "http://127.0.0.1:8008/api/running/sys/platform/OvldComponent/0/cpu_core_excluded" -uadmin:admin | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
if [[ $excluded_cpu =~ "none" ]]; then
    echo "No fast path system."
    fastpath_flag=1
else
    echo "Have fast path system."
    echo "excluded_cpu=" $excluded_cpu
    fastpath_flag=2
fi

#4)Get the number of CPU.Additionally check the quota_us variable to reject if the script runs in VM
#cfs_quota_us=$(cat /sys/fs/cgroup/cpu/$cgroup/cpu.cfs_quota_us)
#in VM cfs_quota_us is -1. Using that as differentiator
#if [[ $cfs_quota_us -le 0 ]] ; then
#fi

#cfs_period_us=$(cat /sys/fs/cgroup/cpu/$cgroup/cpu.cfs_period_us)
#numOfCPU=$((cfs_quota_us / cfs_period_us))
#if [[ $numOfCPU -le 0 ]] ; then
if [[ -v CPULIMIT ]]
then
    if [ $fastpath_flag -eq 2 ]; then
        echo "$cpuLimit=" $cpuLimit
        numOfCPU=$((cpuLimit / 1000))
    else
        numOfCPU=$(echo "scale=1; $cpuLimit / 1000" | bc)
    fi
    echo "numOfCPU=" $numOfCPU
else
    echo "Please export CPULIMIT"
    exit 0
fi
#fi
#if [[ $numOfCPU -le 0 ]] ; then
#    echo 'numOfCPU is invalid'
#    exit 0
#fi

#5)Instantaneous CPU calculation
instantaneous_cpu() {
if [[ $v1v2flag -le 1 ]] ; then
    tstart=$(date +%s%N) && cstart=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage)
    sleep $sleepInterval
    tstop=$(date +%s%N) && cstop=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage) && time=$(date +%s)
    cpu_usage=$(awk "BEGIN {printf \"%.2f\",($cstop-$cstart) / ($tstop - $tstart) * 100 / $numOfCPU  }")
else
    tstart=$(date +%s%N)
        cstart=$(grep "^usage_usec" /sys/fs/cgroup/$cgroup/cpu.stat | awk '{ print $2 *1000 }')
    sleep $sleepInterval
    tstop=$(date +%s%N)
        cstop=$(grep "^usage_usec" /sys/fs/cgroup/$cgroup/cpu.stat | awk '{ print $2 *1000 }') 
    time=$(date +%s)
    cpu_usage=$(awk "BEGIN {printf \"%.2f\",($cstop-$cstart) / ($tstop - $tstart) * 100 / $numOfCPU  }")
fi
}

instant_mem(){
if [[ $v1v2flag -le 1 ]] ; then
    rss=$(grep "^rss " /sys/fs/cgroup/memory/$cgroup/memory.stat | awk '{ print $2 }')
    mem_bytes=$(cat /sys/fs/cgroup/memory/$cgroup/memory.limit_in_bytes)
    mem_usage=$(awk "BEGIN {printf \"%.2f\",($rss / $mem_bytes ) * 100   }")
else
        rss=$(grep "^anon " /sys/fs/cgroup/$cgroup/memory.stat | awk '{ print $2 }')
        mem_bytes=$(cat /sys/fs/cgroup/$cgroup/memory.max)
    mem_usage=$(awk "BEGIN {printf \"%.2f\",($rss / $mem_bytes ) * 100   }")
fi
}

get_slowpath_info() {
excludedcpulist=$excluded_cpu
space=" "
# list slow path cpu list
cpulist=$(taskset -cp 1 | cut -d ":" -f 2 | sed 's/,/ /g')
for j in `echo $cpulist`
do
    if [[ $j == *"-"* ]]; then
        startnum=$(echo $j | cut -d "-" -f 1)
        startend=$(echo $j | cut -d "-" -f 2)
        for (( p=$startnum; p<=$startend; p++ ))
        do
            allcpu+="$p "
        done
        #echo "allcpu=$allcpu"
        continue
    fi
    allcpu+="$j "
done
slowcpulist=$allcpu
echo "allcpulist=" $slowcpulist
i=0
for j in `echo $allcpu`
do
    #echo "$excludedcpulist"
    if [[ "$excludedcpulist" =~ $i ]]; then
        slowcpulist=${slowcpulist/$j}
        #echo "delete" $j "slowcpulist" $slowcpulist
    fi
    ((i++))
done

echo "slowcpulist=" $slowcpulist
IFS=' ' read -r -a slowpath_array <<< "$slowcpulist"
slowpathsize=${#slowpath_array[@]}
}

#)get slow path physical cpu core id.
get_slowpath_cpu_usage() {
totalcpuusage=0
for (( k=0; k<${slowpathsize}; k++ ))
do
    #echo "cpunumber=cpu" ${slowpath_array[k]}
    currentcpuinfo[k]=$(grep "cpu${slowpath_array[k]} " /proc/stat | cut -d " " -f2-)
                
    if [[ -z "${lastcpuinfo[k]}" ]]; then
        #echo "first data ignore."
        totalcpuusage=0
        lastcpuinfo[k]=${currentcpuinfo[k]}
        continue
    fi
    IFS=' ' read -r -a currentcpuinfo_array <<< "${currentcpuinfo[k]}"
    IFS=' ' read -r -a lastcpuinfo_array <<< "${lastcpuinfo[k]}"
    for ((i=0; i<${#lastcpuinfo_array[@]}; i++))
    do
        diff_array[i]=$((currentcpuinfo_array[i]-lastcpuinfo_array[i]))
        #echo "diffcpuinf=[$i]" ${diff_array[i]}
    done
    #calculate cpu usage
    totalcpu=0
    for ((i=0; i<${#diff_array[@]}; i++))
    do
        totalcpu=$((totalcpu + diff_array[i]))
    done
    usedcpu=$((diff_array[0] + diff_array[2] + diff_array[5] + diff_array[6]))
    #echo "usedcpu=" $usedcpu
    #cpuusage=$(echo "scale=2; $usedcpu * 100 / $totalcpu" | bc -l)
    cpuusage=$(echo "$usedcpu $totalcpu" | awk '{printf "%.2f", $1 * 100 / $2}')
    #echo "cpuusage=" $cpuusage
    #totalcpuusage=$(echo "$totalcpuusage + $cpuusage" | bc -l)
    totalcpuusage=$(echo "$totalcpuusage $cpuusage" | awk '{printf "%.2f", $1 + $2}')
    lastcpuinfo[k]=${currentcpuinfo[k]}
done
cpuflag=$(echo "$totalcpuusage" | awk '{print ($0 > 1e-10 || $0 < -1e-10) ? 1 : 0}')
if [[ $cpuflag -eq 1 ]]; then
    #cpu_usage=$(echo "scale=2; $totalcpuusage / $slowpathsize" | bc)
    cpu_usage=$(echo "$totalcpuusage $slowpathsize" | awk '{printf "%.2f", $1 / $2}')
fi
sleep $sleepInterval
#cpu_usage=totalcpuusage
}

#) Average CPU as default OvldComponent table value.  averaging_samples is 10, measurement_interval is 3.
average_cpu_mem() {
if [ $fastpath_flag -eq 2 ]; then
    get_slowpath_info
fi

echo "  DATE      TIME       INS_CPU  AVG_CPU  INS_MEM"
while true;
do
    #calculate instant cpu
    if [ $fastpath_flag -eq 1 ]; then
        instantaneous_cpu
    else
        get_slowpath_cpu_usage
    fi

    #calculate avarage cpu
    count=${#cpu_array[@]}
    if [ $count -ge 10 ] ; then
        cpu_array=("${cpu_array[@]:1}")
    fi
    cpu_array+=("$cpu_usage")
    cpu_sum=0
    for cpu_pre in "${cpu_array[@]}"; do
        #echo "cpu_pre=$cpu_pre"
        #cpu_sum=$(echo "scale=2; $cpu_sum + $cpu_pre" | bc)
        cpu_sum=$(echo "$cpu_sum $cpu_pre" | awk '{printf "%.2f", $1 + $2}')
    done
    ((count++))
    #cpu_avg=$(echo "scale=2; $cpu_sum / $count" | bc)
    cpu_avg=$(echo "$cpu_sum $count" | awk '{printf "%.2f", $1 / $2}')
    #echo "count=$count"

    #calculate instant memory
    instant_mem

    #print instant cpu/average cpu/instant memory
    cpuflag=$(echo "$cpu_avg" | awk '{print ($0 > 1e-10 || $0 < -1e-10) ? 1 : 0}')
    if [[ $cpuflag -eq 1 ]]; then
        echo "$(date +"%d-%m-%Y %T")      $cpu_usage     $cpu_avg     $mem_usage"
    fi
done
}

#8)main()
average_cpu_mem


