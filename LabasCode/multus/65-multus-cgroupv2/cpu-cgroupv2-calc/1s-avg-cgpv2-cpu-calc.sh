#!/bin/bash
# Define the file path
CPU_STAT_FILE="/sys/fs/cgroup/cpu.stat"
# Check if an interval is provided as an argument; otherwise, default to 5 seconds
INTERVAL=${1:-5}
echo "Calculating CPU usage every $INTERVAL seconds..."
while true; do
    # Get the first usage_usec value
    first_value=$(cat "$CPU_STAT_FILE" | grep "usage_usec" | cut -d" " -f2)
    
    # Wait for the interval 1sec.
    sleep 1
    
    # Get the second usage_usec value
    second_value=$(cat "$CPU_STAT_FILE" | grep "usage_usec" | cut -d" " -f2)    # Calculate the difference
    difference=$((second_value - first_value))    # Calculate CPU usage percentage
    cpu_usage=$(echo "scale=2; ($difference / 1000000) * 100" | bc)    # Ensure the output is properly formatted
    cpu_usage=$(printf "%.2f" "$cpu_usage")    # Output the result with a separator
    echo "#############################################################"
    echo "CPU Usage: $cpu_usage%"    # Wait for the specified interval before the next iteration
    sleep "$INTERVAL"
done
