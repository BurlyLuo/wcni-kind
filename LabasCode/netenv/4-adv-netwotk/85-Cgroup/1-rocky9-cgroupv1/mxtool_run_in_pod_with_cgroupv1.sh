#!/bin/bash
#1)Input arguments validation
if [[ $# -ne 2 ]] ; then
    echo "Usage: ./mxTop.sh <sleep interval in secs> <CPU Calculation Type: 1 for average cpu, 2 for per cpu, 3 for per cpu allocated to this pod>"
    echo "Example: ./mxTop.sh 5 2"
    exit 0
fi

#2)Input arguments storing in local variables
sleepInterval=$(echo $1)
echo "sleepInterval=" $sleepInterval
cpuCalcType=$(echo $2)
echo "cpuCalculationType=" $cpuCalcType

#3)Get cgroup path corresponding to the pod
cgroup=$(awk -F: '$2 == "cpu,cpuacct" { print $3 }' /proc/self/cgroup)
if [ -z $cgroup ]; then
    cgroup=$(awk -F: '$2 == "cpuacct,cpu" { print $3 }' /proc/self/cgroup)
fi
echo "cgroup pod path=" $cgroup
if [ -d "/sys/fs/cgroup/cpu/$cgroup/" ]; then
    echo "Using pod specific cgroup path=/sys/fs/cgroup/cpu/$cgroup"
else
    cgroup=""
    echo "Using generic cgroup path /sys/fs/cgroup/cpu/"
fi

#4)Get the number of CPU.Additionally check the quota_us variable to reject if the script runs in VM
cfs_quota_us=$(cat /sys/fs/cgroup/cpu/$cgroup/cpu.cfs_quota_us)
#in VM cfs_quota_us is -1. Using that as differentiator
if [[ $cfs_quota_us -le 0 ]] ; then
    if [[ -v CPULIMIT ]]
    then
        cpuLimit=$(echo "${CPULIMIT//[^0-9.]/}")
        echo "cpuLimit=" $cpuLimit
    else
        echo 'Please use this script only in containerized environment'
        exit 0
    fi
fi
cfs_period_us=$(cat /sys/fs/cgroup/cpu/$cgroup/cpu.cfs_period_us)
numOfCPU=$((cfs_quota_us / cfs_period_us))
echo "numOfCPU=" $numOfCPU
if [[ $numOfCPU -le 0 ]] ; then
    if [[ -v CPULIMIT ]]
    then
        numOfCPU=$((cpuLimit / 1000))
        echo "numOfCPU based on env=" $numOfCPU
    else
        echo "Please export CPULIMIT"
        exit 0
    fi
fi
if [[ $numOfCPU -le 0 ]] ; then
    echo 'numOfCPU is invalid'
    exit 0
fi

#5)Average CPU and memory calculation
avg_cpu_mem() {
echo "  DATE         TIME   CPU  MEM"
while true;
do
        tstart=$(date +%s%N) && cstart=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage)
        sleep $sleepInterval
        tstop=$(date +%s%N) && cstop=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage) && time=$(date +%s)
        #cpu_usage=$(echo -e  "scale=2;($cstop - $cstart) / ($tstop - $tstart) * 100 / $numOfCPU  "|bc -l)
        cpu_usage=$(awk "BEGIN {printf \"%.2f\",($cstop-$cstart) / ($tstop - $tstart) * 100 / $numOfCPU  }")
        rss=$(grep "^rss " /sys/fs/cgroup/memory/$cgroup/memory.stat | awk '{ print $2 }')
        mem_bytes=$(cat /sys/fs/cgroup/memory/$cgroup/memory.limit_in_bytes)
        #mem_usage=$(echo -e  "scale=2;($rss  / $mem_bytes) * 100  "|bc -l)
        mem_usage=$(awk "BEGIN {printf \"%.2f\",($rss / $mem_bytes ) * 100   }")
        echo `date -d @$time +"%d-%m-%Y %T"` $cpu_usage  $mem_usage
done
}

#6)Per CPU calculation
per_cpu() {
while true;
do
        echo "Calculating Per CPU"
        tstart=$(date +%s%N) && cstart=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage_percpu)
        numOfCores=$(echo $cstart | wc -w)
        #echo "numOfCores=" $numOfCores
        cstarttokens=( $cstart )
        #echo ${cstarttokens[*]}
        sleep $sleepInterval
        tstop=$(date +%s%N) && cstop=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage_percpu) && time=$(date +%s)
        cstoptokens=( $cstop )
        #echo ${cstoptokens[*]}
        echo "  DATE      TIME   CPU  USAGE%"
        for ((i=0;i<numOfCores;i++))
        do
          if [ ${cstoptokens[i]} -eq 0 ]
          then
              continue
          fi
          #cpu_usage=$(echo -e  "scale=2;(${cstoptokens[i]} - ${cstarttokens[i]}) / ($tstop - $tstart) * 100 "|bc -l)
          cpu_usage=$(awk "BEGIN {printf \"%.2f\",(${cstoptokens[i]} - ${cstarttokens[i]}) / ($tstop - $tstart) * 100 }")
          cpu_usage="${cpu_usage//[$'\t\r\n ']}"
          #isCpuIdle=$(echo "$cpu_usage==0"|bc -l)
          if (( $(echo "$cpu_usage 0" | awk '{print ($1 == $2)}') ))
          then
              continue
          fi
          echo `date -d @$time +"%d-%m-%Y %T"` "$i" $cpu_usage
        done
        echo "Calculating Average CPU and memory"
        echo "  DATE         TIME   CPU  MEM"
        cstart=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage)
        cstop=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage)
        cpu_usage=$(awk "BEGIN {printf \"%.2f\",($cstop-$cstart) / ($tstop - $tstart) * 100 / $numOfCPU  }")
        rss=$(grep "^rss " /sys/fs/cgroup/memory/$cgroup/memory.stat | awk '{ print $2 }')
        mem_bytes=$(cat /sys/fs/cgroup/memory/$cgroup/memory.limit_in_bytes)
        mem_usage=$(awk "BEGIN {printf \"%.2f\",($rss / $mem_bytes ) * 100   }")
        echo `date -d @$time +"%d-%m-%Y %T"` $cpu_usage  $mem_usage
done
}

#7)Per CPU calculation for only the CPUs allocated to this pod based on taskset
per_cpu_allocated() {
while true;
do
        echo "Calculating Per CPU"
        cpulist=$(taskset -cp 1 | cut -d ":" -f 2 | sed 's/,/ /g')
        tstart=$(date +%s%N) && cstart=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage_percpu)
        numOfCores=$(echo $cstart | wc -w)
        #echo "numOfCores=" $numOfCores
        cstarttokens=( $cstart )
        #echo ${cstarttokens[*]}
        sleep $sleepInterval
        tstop=$(date +%s%N) && cstop=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage_percpu) && time=$(date +%s)
        cstoptokens=( $cstop )
        #echo ${cstoptokens[*]}
        echo "  DATE      TIME   CPU  USAGE%"
        for ((i=0;i<numOfCores;i++))
        do
            for j in `echo $cpulist`;
            do
                #echo numOfCores $i  and cpulist $j
                if [ $j -ne $i ];
                then
                    continue;
                fi
                #cpu_usage=$(echo -e  "scale=2;(${cstoptokens[i]} - ${cstarttokens[i]}) / ($tstop - $tstart) * 100 "|bc -l)
                cpu_usage=$(awk "BEGIN {printf \"%.2f\",(${cstoptokens[i]} - ${cstarttokens[i]}) / ($tstop - $tstart) * 100 }")
                cpu_usage="${cpu_usage//[$'\t\r\n ']}"
                echo `date -d @$time +"%d-%m-%Y %T"` "$i" $cpu_usage
            done
        done
        echo "Calculating Average CPU and memory"
        echo "  DATE         TIME   CPU  MEM"
        cstart=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage)
        cstop=$(cat /sys/fs/cgroup/cpu/$cgroup/cpuacct.usage)
        cpu_usage=$(awk "BEGIN {printf \"%.2f\",($cstop-$cstart) / ($tstop - $tstart) * 100 / $numOfCPU  }")
        rss=$(grep "^rss " /sys/fs/cgroup/memory/$cgroup/memory.stat | awk '{ print $2 }')
        mem_bytes=$(cat /sys/fs/cgroup/memory/$cgroup/memory.limit_in_bytes)
        mem_usage=$(awk "BEGIN {printf \"%.2f\",($rss / $mem_bytes ) * 100   }")
        echo `date -d @$time +"%d-%m-%Y %T"` $cpu_usage  $mem_usage
done
}

#8)main()
if [[ $cpuCalcType -eq 1 ]] ; then
    echo "Calculating Average CPU and memory"
    avg_cpu_mem
elif [[ $cpuCalcType -eq 2 ]] ; then
    echo "Calculating Per CPU overall"
    per_cpu
elif [[ $cpuCalcType -eq 3 ]] ; then
    echo "Calculating Per CPU which are allocated to this pod"
    per_cpu_allocated
else
    echo "Invalid CPU calculation type $cpuCalcType <CPU Calculation Type: 1 for average cpu, 2 for per cpu, 3 for per cpu allocated to this pod>"
    exit 0
fi
