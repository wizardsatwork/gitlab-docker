#!/bin/bash

source ./ENV.sh
source ../bin/tasks.sh

echo "container: $CONTAINER_NAME"

function build() {
  echo "docker building $CONTAINER_NAME"

  docker build \
    --tag=$CONTAINER_NAME \
    --build-arg="DIR=$DIR" \
    --build-arg="PORT=$CONTAINER_PORT" \
    . # dot!

  echo "$CONTAINER_NAME build finished"
}

function run() {
  remove

  echo "starting docker container $CONTAINER_NAME"

  docker run \
    --detach \
    --publish $HOST_PORT_27017:$CONTAINER_PORT_27017 \
    --publish $HOST_PORT_28017:$CONTAINER_PORT_28017 \
    --env MONGODB_USER=$MONGODB_USER \
    --env MONGODB_DATABASE=$MONGODB_DATABASE \
    --env MONGODB_PASS=$MONGODB_PASS \
    $CONTAINER_NAME
}

function help() {
  echo "Container: $CONTAINER_NAME"
  echo ""
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "build  - build docker container"
  echo "run    - run docker container"
  echo "remove - remove container"
  echo "logs   - tail the container logs"
  echo "debug  - connect to container debug session"
  echo "stop   - stop container"
  echo "help   - this help text"
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi

