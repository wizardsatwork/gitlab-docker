#!/bin/bash

function logs() {
  echo "connecting to container logs: $CONTAINER_NAME"
  docker logs --follow $CONTAINER_NAME
}

function stop() {
  echo "stopping $CONTAINER_NAME"
  docker stop $CONTAINER_NAME \
  && echo "stopped $CONTAINER_NAME" \
  || echo "container $CONTAINER_NAME not started"
}

function debug() {
  $PWD/cli.sh build debug

  echo "connecting to container $CONTAINER_NAME-debug"
  docker run \
    --interactive \
    --name "$CONTAINER_NAME-debug" \
    --entrypoint=sh "$CONTAINER_NAME-debug"
}

function remove() {
  echo "removing container $CONTAINER_NAME"
  docker rm -f $CONTAINER_NAME && echo "removed container" || echo "container does not exist"
}
