#!/bin/bash

source ./ENV.sh

echo "container: ${REDIS_CONTAINER_NAME}"

function build() {
  echo "docker building"

  docker build \
    -t ${REDIS_CONTAINER_NAME} \
    --build-arg="DIR=${REDIS_DIR}" \
    --build-arg="USER_ID=${REDIS_USER_ID}" \
    --build-arg="USER_NAME=${REDIS_USER_NAME}" \
    --build-arg="PORT=${REDIS_CONTAINER_PORT}" \
    --rm=true \
    . # dot!

  echo "${REDIS_CONTAINER_NAME} build finished"
}

function debug() {
  echo "starting docker interactive debug session"

  docker run -i -t ${REDIS_CONTAINER_NAME}
}

function rm() {
  echo "removing docker container"

  docker rm -f ${REDIS_CONTAINER_NAME} || echo 'container does not exist'
}

function run() {
  echo "starting docker container"

  rm

  docker run \
    --detach \
    --name ${REDIS_CONTAINER_NAME} \
    -p ${REDIS_HOST_PORT}:${REDIS_CONTAINER_PORT} \
    ${REDIS_CONTAINER_NAME}
}

function help() {
  echo "tasks for ${REDIS_CONTAINER_NAME} container:"
  echo ""
  echo "build - build docker container"
  echo "debug - connect to container shell"
  echo "run - run container"
  echo "rm - remove container"
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

