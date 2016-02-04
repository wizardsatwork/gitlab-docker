#!/bin/bash

source ./ENV.sh
source ../.bin/tasks.sh

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
  echo "tasks for $CONTAINER_NAME container:"
  echo ""
  echo "build - build docker container"
  echo "debug - connect to container shell"
  echo "run - run container"
  echo "remove - remove container"
  echo "help - this help text"
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi

