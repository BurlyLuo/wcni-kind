#!/bin/bash
GATEWAY=$(kubectl get gateway cilium-gw -o jsonpath='{.status.addresses[0].value}')
count_echo1=0
count_echo2=0

while true; do 
    result=$(curl -s -k "http://$GATEWAY/echo")
    count_echo1=$((count_echo1 + $(grep -o "Hostname: echo-1" <<< "$result" | wc -l)))
    count_echo2=$((count_echo2 + $(grep -o "Hostname: echo-2" <<< "$result" | wc -l)))

    echo "Total count of Hostname: echo-1: $count_echo1"
    echo "Total count of Hostname: echo-2: $count_echo2"

    if [ $count_echo2 -ne 0 ]; then
        ratio=$(awk "BEGIN {printf \"%.2f\", $count_echo1/$count_echo2}")
        echo "Ratio of echo-1 to echo-2: $ratio"
    else
        echo "Ratio of echo-1 to echo-2: Undefined (division by zero)"
    fi

    sleep 0.0001
done

