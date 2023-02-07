FROM nginx:alpine
RUN  apk add --no-cache  bind-tools \
     bash \
     curl \
     wget \
     net-tools \
     tcpdump \
     vim \
     tini \
	 ethtool \
	 dhclient \
	 openssh 
	 

EXPOSE 80

COPY default.conf /etc/nginx/conf.d/
COPY .tmux.conf /root/.tmux.conf
COPY entrypoint.sh /
ENTRYPOINT ["/sbin/tini", "-g", "--", "/entrypoint.sh"]
