#!/bin/bash

source ./ENV.sh

function stop() {
  echo "stopping ${GITLAB_CONTAINER_NAME}"
  docker stop ${GITLAB_CONTAINER_NAME}
  echo "stopped"
}

function rm() {
  echo "removing container ${GITLAB_CONTAINER_NAME}"
  docker rm -f ${GITLAB_CONTAINER_NAME} && echo "removed container" || echo "container does not exist"
  echo "container removed"
}

function update() {
  echo "start update of ${GITLAB_CONTAINER_NAME}"
  docker pull ${GITLAB_CONTAINER_NAME}/gitlab-ce:latest
  echo "update finished"
}

function run() {
  rm

  echo "run ${GITLAB_CONTAINER_NAME}"
  docker run --detach \
    --hostname ${GITLAB_HOSTNAME} \
    --publish 0.0.0.0:${GITLAB_CONTAINER_PORT_443}:${GITLAB_HOST_PORT_443} \
    --publish 0.0.0.0:${GITLAB_CONTAINER_PORT_80}:${GITLAB_HOST_PORT_80} \
    --publish 0.0.0.0:${GITLAB_CONTAINER_PORT_22}:${GITLAB_HOST_PORT_22} \
    --name gitlab \
    --restart always \
    --volume config:/etc/gitlab \
    --volume logs:/var/log/gitlab \
    --volume data:/var/opt/gitlab \
    ${GITLAB_CONTAINER_NAME}/gitlab-ce:latest

  echo "started docker container"
}

function help() {
  echo "${GITLAB_CONTAINER_NAME}"
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
