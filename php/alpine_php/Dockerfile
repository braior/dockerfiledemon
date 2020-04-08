# 基础镜像
FROM alpine

# 作者信息
MAINTAINER PHP 7.3.8 Docker Maintainers "braior@163.com"

# 修改源
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories && \
    echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories

# 安装ca 证书
RUN apk update && \
    apk add --no-cache ca-certificates && \
    apk add --no-cache curl bash tree tzdata && \
    cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 设置环境变量
ENV PHP_VERSION 7.3.8
ENV PHPREDIS_VERSION 5.0.0
ENV PHPGRPC_VERSION 1.19.0
ENV PHPPROTOBUF_VERSION 3.6.1
ENV PHPAMQP_VERSION 1.9.4

# 编译安装PHP
RUN PHP_CONFIG="\
    --prefix=/usr/local \
    --exec-prefix=/usr/local \
     --sysconfdir=/etc \
     --with-config-file-path=/etc \
     --with-curl \
     --with-freetype-dir \
     --with-gd \
     --with-gettext \
     --with-iconv-dir \
     --with-kerberos \
     --with-libdir=lib64 \
     --with-libxml-dir \
     --with-mysqli \
     --with-openssl \
     --with-pcre-regex \
     --with-pdo-mysql \
     --with-pdo-sqlite \
     --with-pear \
     --with-png-dir \
     --with-xmlrpc \
     --with-xsl \
     --with-zlib \
     --with-zlib-dir \
     --with-mhash \
     --with-openssl-dir \
     --with-jpeg-dir \
     --enable-fpm \
     --enable-bcmath \
     --enable-libxml \
     --enable-inline-optimization \
     --enable-mbregex \
     --enable-mbstring \
     --enable-opcache \
     --enable-pcntl \
     --enable-shmop \
     --enable-soap \
     --enable-sockets \
     --enable-sysvsem \
     --enable-xml \
     --enable-zip \
     --enable-maintainer-zts \
     --enable-mysqlnd \
     --enable-embedded-mysqli \
" \
     && addgroup -S nginx \
     && adduser -D -S -h /www -s /sbin/nologin -G nginx nginx \
     && apk  add  --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        curl \
        gnupg \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        g++  \
        libstdc++ wget \
        libjpeg  \
        libpng \
        libpng-dev \
        freetype \
        freetype-dev \
        libxml2 \
        libxml2-dev \
        # mysql \
        pcre-dev  \
        curl-dev \
        openssl \
        openssl-dev \
        libmcrypt \
        libmcrypt-dev \
        autoconf \
        libjpeg-turbo-dev \
        libmemcached \
        libmemcached-dev \
        gettext \
        gettext-dev \
        libzip \
        git \
        libzip-dev \
        && curl -fSL  https://www.php.net/distributions/php-$PHP_VERSION.tar.gz -o /tmp/php-$PHP_VERSION.tar.gz \
        && cd /tmp \
        && tar -xzf php-$PHP_VERSION.tar.gz \
        && cd  /tmp/php-$PHP_VERSION \
        && ./configure $PHP_CONFIG --enable-debug \
        && make -j$(getconf _NPROCESSORS_ONLN) \
        && make install \

        && cd /usr/local/bin/ \
        && wget http://pear.php.net/go-pear.phar -O go-pear.php \
        && php go-pear.php \

        && rm -rf /tmp/* \
        && apk del .build-deps

# 安装pecl
RUN apk add --no-cache --virtual .build-deps \
    libc-dev g++ zlib-dev \
    gcc make autoconf \
    cmake \
    wget \
    libjpeg \
    libpng  \
    freetype \
    libxml2 \
    libxslt \
    libmcrypt  \
    libmemcached \
    gettext \
    libzip \
    libressl-dev \
    rabbitmq-c-dev \
    && rm -rf /var/cache/apk/* \

    # git clone -b v3.1.3 https://github.com/php-memcached-dev/php-memcached.git /tmp/php-memcached \
    # && cd /tmp/php-memcached \
    # && phpize \
    # && ./configure --with-php-config=/usr/local/bin/php-config \
    #    --disable-memcached-sasl \
    # && make -j$(getconf _NPROCESSORS_ONLN) \
    # && make install
    
    # amqp 扩展下载 pecl 本地安装
    && wget https://pecl.php.net/get/amqp-${PHPAMQP_VERSION}.tgz -O /tmp/amqp.tgz \
    && pecl install /tmp/amqp.tgz \

    # Redis 扩展下载 pecl本地安装
    && pecl install igbinary \
    && wget http://pecl.php.net/get/redis-${PHPREDIS_VERSION}.tgz -O /tmp/redis.tgz \
    && printf "yes\nyes\n" |pecl install /tmp/redis.tgz \

    # grpc 扩展下载 pecl本地安装
    && wget http://pecl.php.net/get/grpc-${PHPGRPC_VERSION}.tgz -O /tmp/grpc.tgz \
    && pecl install /tmp/grpc.tgz \
    
    # protobuf 扩展下载 pecl本地安装
    && wget https://github.com/google/protobuf/releases/tag/v${PHPPROTOBUF_VERSION} -O /tmp/protobuf.tgz \
    && pecl install protobuf.tgz \

    && rm -rf /tmp/* \
    && apk del .build-deps \

    && apk add  --no-cache \ 
           curl \
           wget \
           libjpeg \
           libpng  \
           freetype \
           libxml2 \
           libxslt \
           libmcrypt  \
           # rabbitmq php拓展必须要用到rabbitmq-c-dev,不能卸载
           rabbitmq-c-dev \
           libmemcached \
           libressl-dev \
           gettext \
           libzip

# copy 配置到镜像中 
# COPY php.ini /etc/php.ini
# COPY php-fpm.conf /etc/php-fpm.conf
# COPY php-fpm.d /etc/php-fpm.d

# Composer安装
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer --ansi --version --no-interaction

# 添加memcached 到配置文件
RUN cd /etc/php-fpm.d && cp www.conf.default www.conf \
    && cp /etc/php-fpm.conf.default /etc/php-fpm.conf \
    && sed -i "s/;daemonize = yes/daemonize = no/" /etc/php-fpm.conf \
    && sed -i "s/user = nobody/user = nginx/" /etc/php-fpm.d/www.conf \
    && sed -i "s/group = nobody/group = nginx/" /etc/php-fpm.d/www.conf \
    && sed -i "s/;listen.owner = nobody/listen.owner = nginx/" /etc/php-fpm.d/www.conf \
    && sed -i "s/;listen.group = nobody/listen.group = nginx/" /etc/php-fpm.d/www.conf \
    && sed -i "s/;listen.mode = 0666/listen.mode = 0666/" /etc/php-fpm.d/www.conf \
    && sed -i "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/" /etc/php-fpm.d/www.conf \
    && echo extension=`find /usr/local/lib/ -name "amqp.so"` >> /etc/php.ini \
    # igbinary反序列化库一定要在redis库加载之前加载
    && echo extension=`find /usr/local/lib/ -name "igbinary.so"` >> /etc/php.ini \
    && echo extension=`find /usr/local/lib/ -name "redis.so"` >> /etc/php.ini \
    && echo extension=`find /usr/local/lib/ -name "grpc.so"` >> /etc/php.ini \
    && echo extension=`find /usr/local/lib/ -name "protobuf.so"` >> /etc/php.ini
    # && echo extension=`find /usr/local/lib/ -name "memcached.so"`>>/etc/php.ini
   
# 开放端口
EXPOSE 9000

STOPSIGNAL SIGTERM

CMD ["/usr/local/sbin/php-fpm", "--fpm-config", "/etc/php-fpm.conf", "--pid", "/var/run/php-fpm.pid"]
