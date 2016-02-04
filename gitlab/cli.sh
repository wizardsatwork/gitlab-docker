#!/bin/bash

GITLAB_VERSION=8.4.1

source ./ENV.sh
source ../.bin/tasks.sh

function build() {
  echo "building: $CONTAINER_NAME"

  docker pull gitlab/gitlab-ce:latest

  echo "build finished"
}

function run() {
  remove

  echo "starting container $CONTAINER_NAME"

  docker run \
    --hostname $HOSTNAME \
    --name $CONTAINER_NAME \
    --detach \
    --link magic-postgres:postgresql \
    --link magic-redis:redisio \
    --publish $HOST_PORT_22:$CONTAINER_PORT_22 \
    --publish $HOST_PORT_80:$CONTAINER_PORT_80 \
    --env "GITLAB_HOST=$HOSTNAME" \
    --env "GITLAB_PORT=$HOST_PORT_80" \
    --env "GITLAB_SSH_PORT=$HOST_PORT_22" \
    --env "DB_NAME=$GITLAB_DB_NAME" \
    --env "DB_USER=$GITLAB_DB_USER" \
    --env "DB_PASS=$GITLAB_DB_PASS" \
    --env "GITLAB_SECRETS_DB_KEY_BASE=$GITLAB_SECRETS_DB_KEY_BASE" \
    --env "OAUTH_GITHUB_API_KEY=$OAUTH_GITHUB_API_KEY" \
    --env "OAUTH_GITHUB_APP_SECRET=$OAUTH_GITHUB_APP_SECRET" \
    --volume $PWD/data:/home/git/data \
    sameersbn/gitlab:$GITLAB_VERSION
}

function backup() {
  echo "backup $CONTAINER_NAME"

  remove

  docker run \
    --name $CONTAINER_NAME \
    --interactive \
    --tty \
    --rm \
    --link magic-postgres:postgresql \
    --link magic-redis:redisio \
    --env "GITLAB_HOST=$HOSTNAME" \
    --env "GITLAB_PORT=$HOST_PORT_80" \
    --env "GITLAB_SSH_PORT=$HOST_PORT_22" \
    --env "DB_NAME=$GITLAB_DB_NAME" \
    --env "DB_USER=$GITLAB_DB_USER" \
    --env "DB_PASS=$GITLAB_DB_PASS" \
    --env "GITLAB_SECRETS_DB_KEY_BASE=$GITLAB_SECRETS_DB_KEY_BASE" \
    --env "OAUTH_GITHUB_API_KEY=$OAUTH_GITHUB_API_KEY" \
    --env "OAUTH_GITHUB_APP_SECRET=$OAUTH_GITHUB_APP_SECRET" \
    --volume $PWD/data:/home/git/data \
    sameersbn/gitlab:$GITLAB_VERSION app:rake gitlab:backup:create

  run
}

function help() {
  echo "${CONTAINER_NAME}"
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "run - run docker container"
  echo "remove - remove container"
  echo "update - update container"
  echo "stop - stop container"
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi
