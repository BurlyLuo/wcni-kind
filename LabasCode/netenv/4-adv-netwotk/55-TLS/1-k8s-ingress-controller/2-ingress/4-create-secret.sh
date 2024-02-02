#!/bin/bash
openssl genrsa -out tls.key 2048 
openssl req -new -x509 -key tls.key -out tls.crt -subj /C=CN/ST=BeiJing/L=BeiJing/O=DevOps/CN=https-example.foo.com
kubectl create secret tls https-example-secret --cert=tls.crt  --key=tls.key 

openssl genrsa -out default-ns-tls.key 2048
openssl req -new -x509 -key default-ns-tls.key -out default-ns-tls.crt -subj /C=CN/ST=BeiJing/L=BeiJing/O=DevOps/CN=default-ns-https-example.foo.com
kubectl create secret tls default-ns-https-example-secret --cert=default-ns-tls.crt  --key=default-ns-tls.key

