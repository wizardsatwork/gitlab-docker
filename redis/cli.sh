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

  echo "starting docker container"

  docker run \
    --detach \
    --name $CONTAINER_NAME \
    --volume $PWD/data:/var/lib/redis \
    --publish $HOST_PORT:$CONTAINER_PORT \
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

