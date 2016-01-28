#!/bin/bash

source ./ENV.sh

function stop() {
  echo "stopping ${CONTAINER_NAME}"
  docker stop ${CONTAINER_NAME} \
  && echo "stopped ${CONTAINER_NAME}" \
  || echo "container ${CONTAINER_NAME} not started"
}

function rm() {
  echo "delete ${CONTAINER_NAME}"
  docker rm -f ${CONTAINER_NAME} && echo "removed container" || echo "container does not exist"
}

function build() {
  echo "building: ${CONTAINER_NAME}"

  docker pull redmine

  echo "build finished"
}

function run() {
  rm

  echo "run ${CONTAINER_NAME}"

  docker run --detach \
    --hostname redmine.wiznwit.com \
    -p 3000:3000 \
    --name ${CONTAINER_NAME} \
    --volume ${PWD}/data:/usr/src/redmine/files \
    --link ${POSTGRES_CONTAINER_NAME}:postgres \
    redmine

  echo "started docker container"
}

function logs() {
  echo "connecting to docker logs"
  docker logs --follow ${CONTAINER_NAME}
}

function help() {
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "run - run docker container"
  echo "rm - remove container"
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
