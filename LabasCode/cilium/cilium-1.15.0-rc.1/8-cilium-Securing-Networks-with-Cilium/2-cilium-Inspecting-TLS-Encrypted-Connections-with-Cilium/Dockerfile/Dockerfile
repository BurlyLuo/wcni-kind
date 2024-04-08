FROM ubuntu/nginx:1.18-22.04_beta
RUN  apt update && apt install -y bind9-utils \
     bash \
     curl \
     wget \
     net-tools \
     tcpdump \
     vim \
     tini \
     ethtool \
     iperf \
     wireguard-tools \
     lrzsz

EXPOSE 80

COPY default.conf /etc/nginx/conf.d/
COPY .tmux.conf /root/.tmux.conf
COPY entrypoint.sh /
RUN sed -i "s/worker_processes auto/worker_processes 1/g" /etc/nginx/nginx.conf
ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/entrypoint.sh"]
