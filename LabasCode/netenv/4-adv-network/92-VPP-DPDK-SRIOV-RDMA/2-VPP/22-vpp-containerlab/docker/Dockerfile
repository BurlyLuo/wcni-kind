FROM ubuntu:noble
ARG DEBIAN_FRONTEND=noninteractive
ARG VPP_INSTALL_SKIP_SYSCTL=true
ARG REPO=release
EXPOSE 22/tcp
RUN apt-get update && apt-get -y install curl procps tcpdump iproute2 iptables \
  iputils-ping net-tools git python3 python3-pip vim-tiny openssh-server \
  mtr-tiny traceroute && apt-get clean

# Install VPP
RUN mkdir -p /var/log/vpp /root/.ssh/ && \
    curl -s https://packagecloud.io/install/repositories/fdio/${REPO}/script.deb.sh | bash && \
    apt-get -y install vpp vpp-plugin-core && apt-get clean

# Build vppcfg
RUN pip install --break-system-packages build netaddr yamale argparse pyyaml ipaddress && \
    git clone https://git.ipng.ch/ipng/vppcfg.git && cd vppcfg && python3 -m build && \
    pip install --break-system-packages dist/vppcfg-*-py3-none-any.whl

# Install FRR
RUN curl -s -o /usr/share/keyrings/frrouting.gpg https://deb.frrouting.org/frr/keys.gpg && \
    echo deb '[signed-by=/usr/share/keyrings/frrouting.gpg]' https://deb.frrouting.org/frr noble frr-stable \
         > /etc/apt/sources.list.d/frr.list && \
    apt -y update && apt -y install frr frr-pythontools && apt clean

# Install Bird2
RUN curl -s -o /usr/share/keyrings/cznic-labs-pkg.gpg https://pkg.labs.nic.cz/gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cznic-labs-pkg.gpg] https://pkg.labs.nic.cz/bird2 noble main" \
         > /etc/apt/sources.list.d/cznic-labs-bird2.list  && \
    apt -y update && apt -y install bird2 && apt clean

# Config files
COPY files/etc/ /etc/
COPY files/init-container.sh /sbin/
RUN chmod 755 /sbin/init-container.sh
CMD ["/sbin/init-container.sh"]
