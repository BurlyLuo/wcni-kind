#!/bin/bash

INTERVAL=2

CPU_AFFINITY=$(taskset -cp 1 | awk -F ': ' '{print $2}' | tr ',' ' ')

CPU_LIST=()
for segment in $CPU_AFFINITY; do
    IFS='-' read -r start end <<< "$segment"
    if [ -z "$end" ]; then
        CPU_LIST+=("$start")
    else
        for (( i=start; i<=end; i++ )); do
            CPU_LIST+=("$i")
        done
    fi
done

max_length=0
first_run=true

while true; do
    output_lines=()
    max_length=0

    while IFS= read -r line; do
        if [[ $line =~ ^%Cpu([0-9]+) ]]; then
            cpu_id=${BASH_REMATCH[1]}
            if [[ " ${CPU_LIST[@]} " =~ " $cpu_id " ]]; then
                output_lines+=( "$line" )
                line_length=${#line}
                if (( line_length > max_length )); then
                    max_length=$line_length
                fi
            fi
        fi
    done < <(top -b 1 -n 1)

    if $first_run; then
        printf '%*s\n' "$max_length" '' | tr ' ' '-'
        first_run=false
    fi

    for line in "${output_lines[@]}"; do
        echo "$line"
    done

    printf '%*s\n' "$max_length" '' | tr ' ' '-'
    
    sleep $INTERVAL
done

