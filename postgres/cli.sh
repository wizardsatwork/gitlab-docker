#!/bin/bash

source ./ENV.sh
source ../tasks.sh

echo "container: ${CONTAINER_NAME}"

function build {
  echo "build postgres database ${CONTAINER_NAME}"
  docker build \
  -t=${CONTAINER_NAME} \
  --build-arg="PORT=${CONTAINER_PORT}" \
  --build-arg="PGDATA=${PGDATA}" \
  --rm=true \
  . # dot!
  echo "build done"
}

function run() {
  rm
  echo "starting container ${CONTAINER_NAME}"
  docker run \
    -i \
    --detach \
    --name ${CONTAINER_NAME} \
    --env POSTGRES_PASSWORD=${PASS} \
    --env POSTGRES_USER=${USER} \
    --volume ${PWD}/data:/home/data/postgresql \
    -p ${HOST_PORT}:${CONTAINER_PORT} \
    ${CONTAINER_NAME}
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
