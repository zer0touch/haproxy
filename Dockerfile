# ADDING COMMENT
FROM zer0touch/ubuntu-systemd
MAINTAINER Ryan Harper <ryan.harper@zer0touch.co.uk>
ENV LBADDR 127.0.0.1

ADD https://releases.hashicorp.com/consul-template/0.16.0/consul-template_0.16.0_linux_amd64.zip /tmp/consul-template.zip
ADD https://releases.hashicorp.com/envconsul/0.6.1/envconsul_0.6.1_linux_amd64.zip /tmp/envconsul.zip

RUN mv /var/lib/apt/lists* /tmp && \
    userdel haproxy && \
    mv /var/cache/apt/archives/partial* /tmp && \
    sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y wget curl keepalived ipcalc openssl psmisc libpcre3 haproxy rsyslog unzip && \
    cd /tmp && \
    mkdir -p /usr/local/bin || /bin/true && \
    unzip consul-template.zip && \
    unzip envconsul.tar.gz && \
    mv consul-template /usr/local/bin/consul-template && \
    mv envconsul /usr/local/bin/envconsul && \
    rm -f /tmp/*.zip && \
    chmod a+x /usr/local/bin/consul-template /usr/local/bin/envconsul && \
    rm -rfv /etc/haproxy/errors && \
    test -d /var/lib/haproxy || mkdir /var/lib/haproxy && \
    id haproxy || useradd haproxy

ADD files/keepalive.default /etc/default/keepalived
ADD files/haproxy.cfg /etc/haproxy/haproxy.cfg
ADD templates/keepalived.template /etc/keepalived/keepalived.template
ADD templates/haproxy.template /etc/haproxy/haproxy.template
ADD services /lib/systemd/system/
ADD scripts/consul-template-start.sh /usr/local/bin/consul-template-start
ADD errors /etc/haproxy/errors

RUN chmod 750 /usr/sbin/haproxy /usr/local/bin/consul-template-start && \  
    systemctl enable keepalived.service && \
    systemctl enable consul-template.service
ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["systemd.unit=emergency.service"]
