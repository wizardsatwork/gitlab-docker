# magic/resty dockerfile
# VERSION   0.0.1

FROM alpine:3.1

MAINTAINER Wizards@Work <dev@wizardsat.work>
ENV REFRESHED_AT 2015-27-12

ENV OPENRESTY_VERSION 1.7.10.1
ENV PATH /usr/local/openresty/nginx/sbin:$PATH

RUN apk --update add ca-certificates pcre libgcc geoip \
    --virtual build-deps \
    build-base \
    readline-dev \
    ncurses-dev \
    pcre-dev \
    zlib-dev \
    openssl-dev \
    perl \
    wget \
    make \
    tar \
    geoip-dev && \
    rm -rf /var/cache/apk/*

RUN \
  mkdir /build_tmp && cd /build_tmp \
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

VOLUME /nginx

WORKDIR /nginx

EXPOSE 80 443

CMD ["nginx", "-p", "/nginx/", "-c", "conf/nginx.conf"]
