docker run \
        --hostname vm \
        --name vm \
        --privileged \
        --security-opt seccomp=unconfined \
        --rm \
        --tmpfs /tmp \
        --tmpfs /run \
        --volume /var \
        --volume /lib/modules:/lib/modules:ro \
        --detach \
        --tty \
        192.168.2.100:5000/kindest/node:v1.27.3

