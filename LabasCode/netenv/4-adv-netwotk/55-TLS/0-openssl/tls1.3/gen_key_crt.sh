openssl ecparam -name prime256v1 -genkey -noout -out ecdsa.key

openssl req -new -x509 -key ecdsa.key -out ecdsa.crt -days 36500 -subj "/CN=wei.luo"
