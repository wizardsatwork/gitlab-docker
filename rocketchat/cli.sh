#!/bin/bash

source ./ENV.sh
source ../bin/tasks.sh

function build() {
  echo "building: $CONTAINER_NAME"

  docker pull rocket.chat

  echo "build finished"
}

function run() {
  remove

  echo "starting container $CONTAINER_NAME"

  docker run \
    --detach \
    --name rocketchat \
    --publish $ROCKETCHAT_HOST_PORT_3000:$ROCKETCHAT_CONTAINER_PORT_3000 \
    --env ROOT_URL=$ROCKETCHAT_URL \
    --link magic-mongodb:db \
    rocket.chat
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
