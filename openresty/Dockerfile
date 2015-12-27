# magic/resty dockerfile
# VERSION   0.0.1

FROM alpine:edge

MAINTAINER Wizards@Work <dev@wizardsat.work>
ENV REFRESHED_AT 2015-27-12

ENV NGINX_VERSION nginx-1.7.11

RUN \
  apk --update add openssl-dev pcre-dev zlib-dev wget build-base \
  && mkdir -p /tmp/src \
  && cd /tmp/src \
  && wget http://nginx.org/download/${NGINX_VERSION}.tar.gz \
  && tar -zxvf ${NGINX_VERSION}.tar.gz \
  && cd /tmp/src/${NGINX_VERSION} \
  && ./configure \
      --with-http_ssl_module \
      --with-http_gzip_static_module \
      --prefix=/etc/nginx \
      --http-log-path=/var/log/nginx/access.log \
      --error-log-path=/var/log/nginx/error.log \
      --sbin-path=/usr/local/sbin/nginx \
  && make \
  && make install \
  && apk del build-base \
  && rm -rf /tmp/src \
  && rm -rf /var/cache/apk/* \

  && tar xvfz ./vendor/ngx_openresty-1.9.7.1.tar.gz \
  && cd ./vendor/ngx_openresty-1.9.7.1 \
  && ./configure \
    --with-luajit \
    --with-http_addition_module \
    --with-http_dav_module \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_image_filter_module \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_xslt_module \
    --with-ipv6 \
    --with-pcre-jit \
  && make \
  && make install \
  && rm -rf /ngx_openresty*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/log/nginx"]

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
