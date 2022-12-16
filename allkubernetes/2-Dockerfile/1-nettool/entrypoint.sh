#!/usr/bin/env sh
trap "echo break; exit 1" SIGINT

while true
do
  echo starting nginx
  echo PodName: $(hostname) \| PodIP: $(ip -o addr | awk '/inet/{print $2,$4}'| grep -v lo | grep -v fe80) > /usr/share/nginx/html/index.html
  nginx -g "daemon off;"
done
