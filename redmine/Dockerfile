# wizardsatwork/grundstein/resty dockerfile
# VERSION 0.0.1

FROM ruby:2.2-slim

MAINTAINER Wizards & Witches <dev@wiznwit.com>
ENV REFRESHED_AT 2016-24-01

ARG USER
ARG GROUP

# add our user and group first to make sure their IDs get assigned consistently,
# regardless of whatever dependencies get added
RUN groupadd -r ${GROUP} && useradd -r -g ${GROUP} ${USER}

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

RUN set -x \
  && curl -fSL "https://github.com/krallin/tini/releases/download/v0.5.0/tini" -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  && tini -h

RUN apt-get update && apt-get install -y --no-install-recommends \
    imagemagick \
    libmysqlclient18 \
    libpq5 \
    libsqlite3-0 \
  && rm -rf /var/lib/apt/lists/*

ARG WORKDIR
WORKDIR ${WORKDIR}

ARG VERSION
RUN echo "redmine version ${VERSION}"

ARG MD5
RUN curl -fSL "http://www.redmine.org/releases/redmine-${VERSION}.tar.gz" -o redmine.tar.gz \
  && echo "${MD5} redmine.tar.gz" | md5sum -c - \
  && tar -xvf redmine.tar.gz --strip-components=1 \
  && rm redmine.tar.gz files/delete.me log/delete.me \
  && mkdir -p tmp/pdf public/plugin_assets \
  && chown -R ${USER}:${GROUP} ./

COPY ./config/database.yml ./config/database.yml

RUN buildDeps='\
    gcc \
    libmagickcore-dev \
    libmagickwand-dev \
    libpq-dev \
    make \
    patch \
  ' \
  && set -ex \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

RUN bundle install --without development test \
  && rm ./config/database.yml \
  && apt-get purge -y --auto-remove $buildDeps

RUN chown -R ${USER}:${GROUP} /usr/src/redmine

VOLUME /usr/src/redmine/files

COPY ./ENV.sh /ENV.sh

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

ARG PORT
EXPOSE ${PORT}
CMD ["rails", "server", "-b", "0.0.0.0"]
