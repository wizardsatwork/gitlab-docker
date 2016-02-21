#!/bin/bash

USER=${MONGODB_USER:-"admin"}
DATABASE=${MONGODB_DATABASE:-"admin"}
PASS=${MONGODB_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${PASS} ] && echo "preset" || echo "random" )

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for MongoDB"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating a ${USER} user with ${_word} password in MongoDB"
mongo admin \
  --eval \
  "\
db.createUser({
  user: '$USER',
  pwd: '$PASS',
  roles:[{
    role:'root',
    db:'admin'
  }]
});"

if [ "$DATABASE" != "admin" ]; then
    echo "=> Creating an ${USER} user with a ${_word} password in MongoDB"
    mongo admin -u $USER -p $PASS << EOF
use $DATABASE
db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE'}]})
EOF
fi
