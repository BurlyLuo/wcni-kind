#!/bin/bash
set -v

kubectl delete ds flannel-ipsec

kubectl delete svc serversvc

