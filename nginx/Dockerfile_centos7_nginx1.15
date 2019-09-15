
# base image
FROM centos:7

# MAINTAINER
MAINTAINER braior@163.com

# running required command
RUN yum install -y gcc gcc-c++ make \
    openssl-devel pcre-devel gd-devel \
    iproute net-tools telnet wget curl && \
    yum clean all && \
    rm -rf /var/cache/yum/*

RUN wget http://nginx.org/download/nginx-1.15.5.tar.gz && \
    tar zxf nginx-1.15.5.tar.gz && \
    cd nginx-1.15.5 &&\
    ./configure --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_stub_status_module && \
    make -j 4 && make install && \
    rm -rf /usr/local/nginx/html/* && \
    useradd -M -s /sbin/nologin nginx && \
    rm -rf nginx-1.15.5* && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

ENV PATH /usr/local/nginx/sbin:$PATH

WORKDIR /usr/local/nginx
EXPOSE 443
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
