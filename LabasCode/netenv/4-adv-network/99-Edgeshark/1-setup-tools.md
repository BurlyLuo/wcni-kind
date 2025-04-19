#!/bin/bash
# 1. Install edgeshark
wget -q --no-cache -O - \
  https://github.com/siemens/edgeshark/raw/main/deployments/nocomposer/edgeshark.sh | bash -s up

# $ docker ps -a 
# 061a267b7856   ghcr.io/siemens/packetflix   "/packetflix --port=…"   2 hours ago         Up 2 hours         5000/tcp, 0.0.0.0:5001->5001/tcp, :::5001->5001/tcp   edgeshark
# dbdfa3430226   ghcr.io/siemens/ghostwire    "/gostwire --http=[:…"   2 hours ago         Up 2 hours                                                               gostwire

# Open edgeshark webui
# firefox http://192.168.2.99:5001

# 2. Install Containershark Extcap Plugin for Wireshark [Ubuntu]
# https://github.com/siemens/cshargextcap?tab=readme-ov-file
cshargextcap=cshargextcap_0.10.7_linux_amd64.deb && wget https://github.com/siemens/cshargextcap/releases/download/v0.10.7/$cshargextcap && dpkg -i ./$cshargextcap  && rm -rf ./$cshargextcap

# 3. Install Containershark Extcap Plugin for Wireshark [Windows]
wget https://github.com/siemens/cshargextcap/releases/download/v0.10.7/cshargextcap_0.10.7_windows_amd64.zip
