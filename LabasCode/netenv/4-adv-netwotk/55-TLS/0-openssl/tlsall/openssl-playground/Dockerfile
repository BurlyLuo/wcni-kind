FROM debian:10

WORKDIR /
RUN apt update
RUN apt install -y build-essential make wget perl
RUN DEBIAN_FRONTEND=noninteractive apt install -y tshark

# --- Certificates ---
WORKDIR /
RUN mkdir -p /etc/ssl/csr /etc/ssl/certs /etc/ssl/private && \
  openssl genrsa -out /etc/ssl/private/server.key 2048 && \
  openssl req -new -key /etc/ssl/private/server.key -out /etc/ssl/csr/server.csr -subj "/C=JP/ST=Tokyo/O=TeX2e/CN=localhost" && \
  openssl x509 -req -in /etc/ssl/csr/server.csr -signkey /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt -days 365

# --- OpenSSL 1.1.1j ---
WORKDIR /tmp
RUN wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1j.tar.gz && \
  tar -xf openssl-1.1.1j.tar.gz
WORKDIR /tmp/openssl-1.1.1j
RUN mkdir -p /opt/openssl-1.1.1j/ssl && \
  ln -s /etc/ssl/openssl.cnf /opt/openssl-1.1.1j/ssl/openssl.cnf && \
  ./config --prefix=/opt/openssl-1.1.1j && \
  make -j4 && \
  make install_sw

# --- OpenSSL 1.0.2k ---
WORKDIR /tmp
RUN wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz && \
  tar -xf openssl-1.0.2k.tar.gz
WORKDIR /tmp/openssl-1.0.2k
RUN mkdir -p /opt/openssl-1.0.2k/ssl && \
  ln -s /etc/ssl/openssl.cnf /opt/openssl-1.0.2k/ssl/openssl.cnf && \
  ./config --prefix=/opt/openssl-1.0.2k && \
  make -j4 && \
  make install_sw


WORKDIR /tmp

CMD ["/bin/bash"]
