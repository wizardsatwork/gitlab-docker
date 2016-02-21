#!/bin/bash

source ./ENV.sh

function init() {
  export $MONGODB_USER=$ROCKETCHAT_DB_USER
  export $MONGODB_PASS=$ROCKETCHAT_DB_PASS
  export $MONGODB_DATABASE=$ROCKETCHAT_DB_DATABASE

  ./add_user.sh
}
