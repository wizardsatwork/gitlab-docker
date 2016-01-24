# wizardsatwork/grundstein/redis dockerfile
# VERSION 0.0.1

FROM alpine:3.3

MAINTAINER Wizards & Witches <dev@wiznwit.com>
ENV REFRESHED_AT 2016-24-01

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && \
  apk add --update redis && rm -rf /var/cache/apk/*

ARG DIR
ARG USER_ID
ARG USER_NAME
ARG PORT

RUN \
  adduser \
  -h ${DIR} \
  -s /bin/sh \
  -u ${USER_ID} \
  -D ${USER_NAME} ${USER_NAME}

USER ${USER_NAME}

# Define mountable directories.
VOLUME ["${DIR}/data"]

# Define working directory.
WORKDIR ${DIR}/data

# Define default command.
CMD ["redis-server"]

# Expose ports.
EXPOSE ${PORT}
