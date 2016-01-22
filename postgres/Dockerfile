FROM alpine:3.3
MAINTAINER  Wizards@Work <dev@wizardsat.work>

ARG POSTGRES_CONTAINER_PORT
ARG PGDATA

ADD ./ENV /ENV

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && apk update \
    && apk add curl "postgresql@edge>9.4" \
    && mkdir /docker-entrypoint-initdb.d \
    && curl \
        -o /usr/local/bin/gosu \
        -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && chmod +x /usr/local/bin/gosu \
    && apk del curl \
    && rm -rf /var/cache/apk/*

VOLUME ${PGDATA}

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE ${POSTGRES_CONTAINER_PORT}

CMD ["postgres"]
