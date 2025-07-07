FROM redis
RUN apt update && \
    apt install -y net-tools vim iproute2 iputils-ping procps curl wget tcpdump && \
    apt clean && \
    apt autoremove --yes && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
