#!/bin/sh

source /ENV
rm /ENV

chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
    gosu postgres initdb
    sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

    : ${USER:="postgres"}
    : ${DB:=$USER}

    if [ "$PASS" ]; then
      pass="PASSWORD '$PASS'"
      authMethod=md5
    else
      echo "==============================="
      echo "!!! Use \$PASS env var to secure your database !!!"
      echo "==============================="
      pass=
      authMethod=trust
    fi
    echo

    if [ "$DB" != 'postgres' ]; then
      createSql="CREATE DATABASE $DB;"
      echo $createSql | gosu postgres postgres --single -jE
      echo
    fi

    if [ "$USER" != 'postgres' ]; then
      op=CREATE
    else
      op=ALTER
    fi

    userSql="$op USER $USER WITH SUPERUSER $pass;"
    echo $userSql | gosu postgres postgres --single -jE
    echo

    # internal start of server in order to allow set-up using psql-client
    # does not listen on TCP/IP and waits until start finishes
    gosu postgres pg_ctl -D "$PGDATA" \
        -o "-c listen_addresses=''" \
        -w start

    echo
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sh)  echo "$0: running $f"; . "$f" ;;
            *.sql) echo "$0: running $f"; psql --username "$USER" --dbname "$DB" < "$f" && echo ;;
            *)     echo "$0: ignoring $f" ;;
        esac
        echo
    done

    gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop

    { echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA"/pg_hba.conf
fi

exec gosu postgres "$@"
