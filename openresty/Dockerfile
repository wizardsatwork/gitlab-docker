# magic/resty dockerfile
# VERSION   0.0.1

FROM alpine:edge

MAINTAINER Wizards@Work <dev@wizardsat.work>
ENV REFRESHED_AT 2015-27-12

ENV NGINX_VERSION nginx-1.7.11

ADD ./app.lua /app.lua

ADD ./vendor /vendor

RUN apk --update add openssl-dev wget

RUN \
  mkdir -p /vendor \
  && cd /vendor \
  && wget http://openresty.org/download/ngx_openresty-1.9.7.1.tar.gz \
  && tar xvfz /vendor/ngx_openresty-1.9.7.1.tar.gz \
  && cd /vendor/ngx_openresty-1.9.7.1 \
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
  && cd / \
  && rm -rf /vendor

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/log/nginx"]

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
