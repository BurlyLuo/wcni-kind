# Where /myredis/conf/ is a local directory containing your redis.conf file. Using this method means that there is no need for you to have a Dockerfile for your redis container.

# The mapped directory should be writable, as depending on the configuration and mode of operation, Redis may need to create additional configuration files or rewrite existing ones.

# Alternatively, you can specify something along the same lines with docker run options.

docker run -v ./:/usr/local/etc/redis --name myredis 192.168.2.100:5000/redis:v1 redis-server /usr/local/etc/redis/redis.conf
