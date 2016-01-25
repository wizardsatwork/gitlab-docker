#!/bin/bash

source ./ENV.sh

echo "container: ${OPENRESTY_CONTAINER_NAME}"

function build {
  echo "build openresty ${OPENRESTY_CONTAINER_NAME}"
  docker build \
    -t=${OPENRESTY_CONTAINER_NAME} \
    --build-arg="TARGET_DIR=${OPENRESTY_TARGET_DIR}" \
    --build-arg="PORT_80=${OPENRESTY_CONTAINER_PORT_80}" \
    --build-arg="PORT_443=${OPENRESTY_CONTAINER_PORT_443}" \
    --build-arg="VERSION=${OPENRESTY_VERSION}" \
    --build-arg="SBIN=${OPENRESTY_SBIN}" \
    --rm=true \
    . # dot!
  echo "build done"
}

function debug() {
  echo "connecting to container ${OPENRESTY_CONTAINER_NAME}"
  docker run \
    -i \
    --name ${OPENRESTY_CONTAINER_NAME} \
    --entrypoint=sh ${OPENRESTY_CONTAINER_NAME}
}

function rm() {
  echo "removing container"
  docker rm -f ${OPENRESTY_CONTAINER_NAME} || echo "container does not exist"
}

function run() {
  rm
  echo "starting container"
  docker run \
    -i \
    --detach \
    --name ${OPENRESTY_CONTAINER_NAME} \
    -p ${OPENRESTY_HOST_PORT}:${OPENRESTY_CONTAINER_PORT} \
    ${OPENRESTY_CONTAINER_NAME}
}

function logs() {
  echo "connecting to logs"
  docker logs -f ${OPENRESTY_CONTAINER_NAME}
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
