FROM ubuntu:latest
RUN apt update && apt install -y openssh-server nano curl iproute2 unzip dnsutils wget
# Configure SSH
RUN mkdir /var/run/sshd
RUN mkdir /opt/wpp
RUN echo 'root:Abc86420' | chpasswd
RUN curl -o /root/wpp.zip -L https://github.com/bepass-org/warp-plus/releases/download/v1.1.3/warp-plus_linux-amd64.zip
RUN cd /root && unzip /root/wpp.zip && rm wpp.zip
RUN echo '{' >> /root/config.json
RUN echo '  "verbose": false,' >> /root/config.json
RUN echo '  "bind": "0.0.0.0:8881",' >> /root/config.json
RUN echo '  "endpoint": "162.159.192.228:1180",' >> /root/config.json
RUN echo '  "key": "018HlL7s-As1v95F4-324osuD9",' >> /root/config.json
RUN echo '  "gool": true,' >> /root/config.json
RUN echo '  "cfon": false,' >> /root/config.json
RUN echo '  "country": "US",' >> /root/config.json
RUN echo '  "scan": false,' >> /root/config.json
RUN echo '  "rtt": "1000ms"' >>/root/config.json
RUN echo '}' >> /root/config.json
RUN echo 'nohup /root/warp-plus -c /root/config.json &'>> /root/wpp.sh && chmod +x /root/wpp.sh
EXPOSE 8881
WORKDIR /root
CMD ["sh", "/root/wpp.sh"]
#password for user login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22
# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]
