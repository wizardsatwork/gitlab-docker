#!/bin/bash

source ./ENV.sh

echo "container: ${CONTAINER_NAME}"

function stop() {
  echo "stopping ${CONTAINER_NAME}"

  docker stop ${CONTAINER_NAME} \
  && echo "stopped ${CONTAINER_NAME}" \
  || echo "container ${CONTAINER_NAME} not started"
}

function build {
  echo "build openresty ${CONTAINER_NAME}"

  docker build \
    -t=${CONTAINER_NAME} \
    --build-arg="TARGET_DIR=${TARGET_DIR}" \
    --build-arg="PORT_80=${CONTAINER_PORT_80}" \
    --build-arg="PORT_443=${CONTAINER_PORT_443}" \
    --build-arg="VERSION=${VERSION}" \
    --build-arg="SBIN=${SBIN}" \
    --rm=true \
    . # dot!

  echo "build done"
}

function debug() {
  echo "connecting to container ${CONTAINER_NAME}"
  docker run \
    -i \
    --name ${CONTAINER_NAME} \
    --entrypoint=sh ${CONTAINER_NAME}
}

function rm() {
  echo "removing container"

  docker rm -f ${CONTAINER_NAME} \
  && echo "container removed" \
  || echo "container does not exist"
}

function run() {
  rm
  echo "starting container"
  docker run \
    -i \
    --detach \
    --name ${CONTAINER_NAME} \
    -p ${HOST_PORT}:${CONTAINER_PORT} \
    ${CONTAINER_NAME}
}

function logs() {
  echo "connecting to logs"
  docker logs -f ${CONTAINER_NAME}
}

function help() {
  echo "USAGE:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "build - docker builds the container"
  echo "run - docker runs the container"
  echo "rm - docker remove the container"
  echo "logs - tail the docker logs"
  echo "debug - connect to the container"
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
else
  help $@
fi
