#!/bin/bash

source ./ENV.sh
source ../tasks.sh

function build() {
  echo "building: $CONTAINER_NAME"

  docker pull gitlab/gitlab-ce:latest

  echo "build finished"
}

function run-orig() {
  rm

  echo "run $CONTAINER_NAME"
  docker run --detach \
    --hostname $HOSTNAME \
    --publish 0.0.0.0:$CONTAINER_PORT_443:$HOST_PORT_443 \
    --publish 0.0.0.0:$CONTAINER_PORT_80:$HOST_PORT_80 \
    --publish 0.0.0.0:$CONTAINER_PORT_22:$HOST_PORT_22 \
    --name $CONTAINER_NAME \
    --restart always \
    --volume config:/etc/gitlab \
    --volume logs:/var/log/gitlab \
    --volume data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

  echo "started docker container"
}

function run() {
  rm

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
    --env "GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string-232323" \
    --volume $PWD/data:/home/git/data \
    sameersbn/gitlab:8.4.1
}

function help() {
  echo "${CONTAINER_NAME}"
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "run - run docker container"
  echo "rm - remove container"
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
