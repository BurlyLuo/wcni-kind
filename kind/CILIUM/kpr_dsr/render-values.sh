#!/bin/bash
CLUSTER_NAME=example-kpr-dsr
CPLANE_IP=$(docker inspect $CLUSTER_NAME-control-plane -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
cat values.yaml.template | sed "s/REPLACEME/$CPLANE_IP/g" > values.yaml
