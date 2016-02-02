#!/bin/bash

source ./ENV.sh
source ../tasks.sh

echo "container: $CONTAINER_NAME"

function build() {
  echo "building: $CONTAINER_NAME"

  docker pull redmine

  mkdir -p ./data/plugins

  if [ -d "./data/plugins/redmine_milestones" ]; then
    echo "redmine_milestones already installed"
  else
    git clone \
      git://github.com/k41n/redmine_milestones.git \
      ./data/plugins/redmine_milestones \
    || echo "milestones plugin already downloaded"
  fi

  echo "build finished"
}

function run() {
  remove

  echo "run $CONTAINER_NAME"

  docker run \
    --detach \
    --hostname $HOSTNAME \
    --publish $HOST_PORT_80:$CONTAINER_PORT_80 \
    --name $CONTAINER_NAME \
    --volume=$PWD/data:/home/redmine/data \
    --volume=$PWD/logs:/home/redmine/redmine/log/ \
    --link $POSTGRES_CONTAINER_NAME:postgres \
    --env='REDMINE_FETCH_COMMITS=true' \
    --env='NGINX_ENABLED=false' \
    $CONTAINER_NAME

  echo "started docker container"
}

function help() {
  echo "Usage:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "run - run docker container"
  echo "remove - remove container"
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
