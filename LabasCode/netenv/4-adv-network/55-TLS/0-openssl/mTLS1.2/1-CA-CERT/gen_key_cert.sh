# Server CA

# 生成 CA_Server 私钥
openssl genrsa -out CA_Server.key 2048

# 生成自签名的 CA_Server 根证书
openssl req -new -x509 -key CA_Server.key -out CA_Server.crt -days 3650 -subj "/CN=CA_Server"

# 生成服务端私钥
openssl genrsa -out server.key 2048

# 生成服务端 CSR
openssl req -new -key server.key -out server.csr -subj "/CN=server.weiluo.com"

# 使用 CA_Server 签发服务端证书
openssl x509 -req -in server.csr -CA CA_Server.crt -CAkey CA_Server.key -CAcreateserial -out server.crt -days 3650



# Client CA
# 生成 CA_Client 私钥
openssl genrsa -out CA_Client.key 2048

# 生成自签名的 CA_Client 根证书
openssl req -new -x509 -key CA_Client.key -out CA_Client.crt -days 3650 -subj "/CN=CA_Client"


# 生成客户端私钥
openssl genrsa -out client.key 2048

# 生成客户端 CSR
openssl req -new -key client.key -out client.csr -subj "/CN=client.weiluo.com"

# 使用 CA_Client 签发客户端证书
openssl x509 -req -in client.csr -CA CA_Client.crt -CAkey CA_Client.key -CAcreateserial -out client.crt -days 3650


