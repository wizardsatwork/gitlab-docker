#!/bin/bash

source ./ENV.sh

function stop() {
  echo "stopping ${REDMINE_CONTAINER_NAME}"
  docker stop ${REDMINE_CONTAINER_NAME}
}

function rm() {
  echo "delete ${REDMINE_CONTAINER_NAME}"
  docker rm -f ${REDMINE_CONTAINER_NAME} && echo "removed container" || echo "container does not exist"
}

function build() {
  echo "building: ${REDMINE_CONTAINER_NAME}"

  docker build \
    -t ${REDMINE_CONTAINER_NAME} \
    --build-arg="USER=${REDMINE_USER}" \
    --build-arg="GROUP=${REDMINE_GROUP}" \
    --build-arg="WORKDIR=${REDMINE_WORKDIR}" \
    --build-arg="VERSION=${REDMINE_VERSION}" \
    --build-arg="MD5=${REDMINE_MD5}" \
    --build-arg="RAILS_ENV=${REDMINE_RAILS_ENV}" \
    --build-arg="PORT=${REDMINE_CONTAINER_PORT}" \
    . # dot!

  echo "build finished"
}

function run() {
  rm

  echo "run ${REDMINE_CONTAINER_NAME}"

  docker run \
    --name ${REDMINE_CONTAINER_NAME} \
    --detach \
    --link=magic-postgres:postgresql \
    --publish=10083:80 \
    --volume=data:/home/redmine/data \
    ${REDMINE_CONTAINER_NAME}

  echo "started docker container"
}

function logs() {
  echo "connecting to docker logs"
  docker logs ${REDMINE_CONTAINER_NAME}
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
