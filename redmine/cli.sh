#!/bin/bash

source ./ENV.sh
source ../tasks.sh

echo "container: $CONTAINER_NAME"

function build() {
  echo "building: $CONTAINER_NAME"

  docker pull redmine

  echo "build finished"
}

function run() {
  remove

  echo "run $CONTAINER_NAME"

  docker run \
    --detach \
    --hostname $HOSTNAME \
    --publish $HOST_PORT_80:$CONTAINER_PORT_80 \
    --name $CONTAINER_NAME \
    --volume $PWD/data:/usr/src/redmine/files \
    --link $POSTGRES_CONTAINER_NAME:postgres \
    redmine

  echo "started docker container"
}

function help() {
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "run - run docker container"
  echo "remove - remove container"
  echo "build - build container"
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
