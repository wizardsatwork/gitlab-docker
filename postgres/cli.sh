#!/bin/bash

source ./ENV.sh
source ../bin/tasks.sh

echo "container: $CONTAINER_NAME"

function build {
  echo "build postgres database $CONTAINER_NAME"
  docker build \
  --tag=$CONTAINER_NAME \
  --build-arg="PORT=$CONTAINER_PORT" \
  --build-arg="PGDATA=$PGDATA" \
  . # dot!
  echo "build done"
}

function run() {
  remove

  echo "starting container $CONTAINER_NAME"

  docker run \
    --detach \
    --name ${CONTAINER_NAME} \
    --env "POSTGRES_PASSWORD=$SU_PASS" \
    --env "POSTGRES_USER=$SU_USER" \
    --env "DB=$DB" \
    --env "SU_PASS=$SU_PASS" \
    --env "SU_USER=$SU_USER" \
    --env "PGDATA=$PGDATA" \
    --env "GITLAB_DB_USER=$GITLAB_DB_USER" \
    --env "GITLAB_DB_PASS=$GITLAB_DB_PASS" \
    --env "GITLAB_DB_NAME=$GITLAB_DB_NAME" \
    --env "REDMINE_DB_USER=$REDMINE_DB_USER" \
    --env "REDMINE_DB_PASS=$REDMINE_DB_PASS" \
    --env "REDMINE_DB_NAME=$REDMINE_DB_NAME" \
    --volume $PWD/data:/home/data/postgresql \
    --publish $HOST_PORT:$CONTAINER_PORT \
    $CONTAINER_NAME
}

function help() {
  echo "USAGE:"
  echo ""
  echo './cli.sh $command'
  echo ""
  echo "commands:"
  echo "build - docker builds the container"
  echo "run - docker runs the container"
  echo "remove - docker remove the container"
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
