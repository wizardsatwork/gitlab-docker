FROM alpine:3.3
MAINTAINER  Wizards@Work <dev@wizardsat.work>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && \
  apk add --update redis && rm -rf /var/cache/apk/*

RUN \
  adduser \
  -h /home/redis \
  -s /bin/sh \
  -u 40561 \
  -D wnwredis wnwredis

USER wnwredis

# Define mountable directories.
VOLUME ["/srv/data/redis"]

# Define working directory.
WORKDIR /srv/data/redis

# Define default command.
CMD ["redis-server"]

# Expose ports.
EXPOSE 6379
