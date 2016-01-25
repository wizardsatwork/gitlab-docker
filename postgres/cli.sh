#!/bin/bash

source ./ENV.sh

echo "container: ${POSTGRES_CONTAINER_NAME}"

function build {
  echo "build postgres database ${POSTGRES_CONTAINER_NAME}"
  docker build \
  -t=${POSTGRES_CONTAINER_NAME} \
  --build-arg="PORT=${POSTGRES_CONTAINER_PORT}" \
  --build-arg="PGDATA=${PGDATA}" \
  --rm=true \
  . # dot!
  echo "build done"
}

function debug() {
  echo "connecting to container ${POSTGRES_CONTAINER_NAME}"
  docker run \
    -i \
    --name ${POSTGRES_CONTAINER_NAME} \
    --entrypoint=sh ${POSTGRES_CONTAINER_NAME}
}

function rm() {
  echo "removing container"
  docker rm -f ${POSTGRES_CONTAINER_NAME} || echo "container does not exist"
}

function run() {
  rm
  echo "starting container"
  docker run \
    -i \
    --detach \
    --name ${POSTGRES_CONTAINER_NAME} \
    -p ${POSTGRES_HOST_PORT}:${POSTGRES_CONTAINER_PORT} \
    ${POSTGRES_CONTAINER_NAME}
}

function logs() {
  echo "connecting to logs"
  docker logs -f ${POSTGRES_CONTAINER_NAME}
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
