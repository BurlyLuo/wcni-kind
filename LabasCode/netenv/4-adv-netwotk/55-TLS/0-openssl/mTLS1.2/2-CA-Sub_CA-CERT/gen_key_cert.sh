#!/bin/bash

# 清理旧文件
rm -f *.key *.crt *.csr *.srl *.cnf

# ====================
# 服务端证书链
# ====================

echo "生成服务端证书链..."

# 生成 Root CA（服务端）
openssl genrsa -out CA_Server.key 2048
openssl req -new -x509 -key CA_Server.key -out CA_Server.crt -days 3650 -subj "/CN=Root_CA_Server"

# 生成 Intermediate CA（服务端）
openssl genrsa -out Intermediate_Server.key 2048
openssl req -new -key Intermediate_Server.key -out Intermediate_Server.csr -subj "/CN=Intermediate_CA_Server"

# 创建临时扩展配置文件
cat > intermediate_ext.cnf <<EOF
[ v3_ca ]
basicConstraints = CA:TRUE
EOF

# 使用 Root CA 签发 Intermediate CA 证书（服务端）
openssl x509 -req \
    -in Intermediate_Server.csr \
    -CA CA_Server.crt \
    -CAkey CA_Server.key \
    -CAcreateserial \
    -out Intermediate_Server.crt \
    -days 3650 \
    -extfile intermediate_ext.cnf \
    -extensions v3_ca

# 生成服务端证书
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=server.weiluo.com"
openssl x509 -req \
    -in server.csr \
    -CA Intermediate_Server.crt \
    -CAkey Intermediate_Server.key \
    -CAcreateserial \
    -out server.crt \
    -days 3650 \
    -extfile <(echo "subjectAltName=DNS:server.weiluo.com")

# ====================
# 客户端证书链
# ====================

echo "生成客户端证书链..."

# 生成 Root CA（客户端）
openssl genrsa -out CA_Client.key 2048
openssl req -new -x509 -key CA_Client.key -out CA_Client.crt -days 3650 -subj "/CN=Root_CA_Client"

# 生成 Intermediate CA（客户端）
openssl genrsa -out Intermediate_Client.key 2048
openssl req -new -key Intermediate_Client.key -out Intermediate_Client.csr -subj "/CN=Intermediate_CA_Client"

# 使用 Root CA 签发 Intermediate CA 证书（客户端）
openssl x509 -req \
    -in Intermediate_Client.csr \
    -CA CA_Client.crt \
    -CAkey CA_Client.key \
    -CAcreateserial \
    -out Intermediate_Client.crt \
    -days 3650 \
    -extfile intermediate_ext.cnf \
    -extensions v3_ca

# 生成客户端证书
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr -subj "/CN=client.weiluo.com"
openssl x509 -req \
    -in client.csr \
    -CA Intermediate_Client.crt \
    -CAkey Intermediate_Client.key \
    -CAcreateserial \
    -out client.crt \
    -days 3650 \
    -extfile <(echo "subjectAltName=DNS:client.weiluo.com")
# ====================
# 配置信任链
# ====================

echo "配置信任链..."
# 服务端信任链（信任客户端证书链）
cat Intermediate_Client.crt CA_Client.crt > CA_chain_client_for_server.crt

# 客户端信任链（信任服务端证书链）
cat Intermediate_Server.crt CA_Server.crt > CA_chain_server_for_client.crt

cat server.crt Intermediate_Server.crt CA_Server.crt > server_full_chain.crt
echo server_full_chain.crt ok
