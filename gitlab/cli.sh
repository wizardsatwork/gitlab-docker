#!/bin/bash

source ./ENV.sh

function stop() {
  echo "stopping ${CONTAINER_NAME}"
  docker stop ${CONTAINER_NAME} \
  && echo "stopped ${CONTAINER_NAME}" \
  || echo "container ${CONTAINER_NAME} not started"
}

function rm() {
  echo "removing container ${CONTAINER_NAME}"
  docker rm -f ${CONTAINER_NAME} && echo "removed container" || echo "container does not exist"
  echo "container removed"
}

function update() {
  echo "start update of ${CONTAINER_NAME}"
  docker pull ${CONTAINER_NAME}/gitlab-ce:latest
  echo "update finished"
}

function logs() {
  docker logs --follow $CONTAINER_NAME
}

function run() {
  rm

  echo "run ${CONTAINER_NAME}"
  docker run --detach \
    --hostname ${HOSTNAME} \
    --publish 0.0.0.0:${CONTAINER_PORT_443}:${HOST_PORT_443} \
    --publish 0.0.0.0:${CONTAINER_PORT_80}:${HOST_PORT_80} \
    --publish 0.0.0.0:${CONTAINER_PORT_22}:${HOST_PORT_22} \
    --name gitlab \
    --restart always \
    --volume config:/etc/gitlab \
    --volume logs:/var/log/gitlab \
    --volume data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

  echo "started docker container"
}

function help() {
  echo "${CONTAINER_NAME}"
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "run - run docker container"
  echo "rm - remove container"
  echo "update - update container"
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
