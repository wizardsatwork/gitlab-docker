# magic/resty dockerfile
# VERSION   0.0.1

FROM alpine:3.3

MAINTAINER Wizards@Work <dev@wizardsat.work>
ENV REFRESHED_AT 2015-27-12

ENV OPENRESTY_VERSION 1.9.7.1
ENV PATH /usr/local/openresty/nginx/sbin:$PATH

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --update --virtual build-deps \
  ca-certificates \
  pcre \
  libgcc \
  geoip \
  build-base \
  readline-dev \
  ncurses-dev \
  pcre-dev \
  zlib-dev \
  openssl-dev \
  perl \
  wget \
  curl \
  make \
  tar \
  geoip-dev \
  git \
  unzip \
  openrc \
  lua5.1 \
  lua5.1-dev \
  luarocks5.1 \
  && rm -rf /var/cache/apk/*

#install openresty
RUN \
  mkdir /build_tmp \
  && cd /build_tmp \
  && wget http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz \
  && tar xf ngx_openresty-${OPENRESTY_VERSION}.tar.gz \
  && cd ngx_openresty-${OPENRESTY_VERSION} \
  && ./configure \
    --with-pcre-jit \
    --with-ipv6 \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
  && make \
  && make install \
  && rm -rf /build_tmp

RUN luarocks-5.1 install lapis

ENV TARGET_DIR /home

# add sources
ADD ./out ${TARGET_DIR}/

# add log directory and pipe it to stdout
RUN mkdir ${TARGET_DIR}/logs \
  && ln -sf /dev/stdout ${TARGET_DIR}/logs/access.log

# Expose ports
EXPOSE 80 443

WORKDIR ${TARGET_DIR}
