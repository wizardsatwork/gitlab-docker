#!/bin/sh

echo "yay start building postgres data ${GILAB_USER_PASS}"

chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
  gosu postgres initdb
  sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

  : ${SU_USER:="postgres"}
  : ${DB:=$SU_USER}

  if [ "$SU_PASS" ]; then
    pass="PASSWORD '$SU_PASS'"
    authMethod=md5
  else
    echo "==============================="
    echo "!!! Use \$SU_PASS env var to secure your database !!!"
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

  if [ "$SU_USER" != 'postgres' ]; then
    op=CREATE
  else
    op=ALTER
  fi

  userSql="$op USER $SU_USER WITH SUPERUSER $pass;"
  echo $userSql | gosu postgres postgres --single -jE
  echo


  if [ "$GITLAB_DB_USER" ]; then
    gitlabSql="CREATE ROLE $GITLAB_DB_USER WITH LOGIN CREATEDB PASSWORD '$GITLAB_DB_PASS';"
    echo $gitlabSql | gosu postgres postgres --single -jE
  fi

  if [ "$GITLAB_DB_NAME" ]; then
    createGitlabSql="CREATE DATABASE $GITLAB_DB_NAME;"
    echo $createGitlabSql | gosu postgres postgres --single -jE
    fixGitlabPermissions="GRANT ALL PRIVILEGES ON DATABASE ${GITLAB_DB_NAME} to ${GITLAB_DB_USER};"
    echo $fixGitlabPermissions | gosu postgres postgres --single -jE
    echo
  fi

  if [ "REDMINE_DB_USER" ]; then
    redmineSql="CREATE ROLE $REDMINE_DB_USER WITH LOGIN CREATEDB PASSWORD '$REDMINE_DB_PASS';"
    echo $redmineSql | gosu postgres postgres --single -jE
  fi

  if [ "$REDMINE_DB_NAME" ]; then
    createRedmineSql="CREATE DATABASE $REDMINE_DB_NAME;"
    echo $createRedmineSql | gosu postgres postgres --single -jE
    fixGitlabPermissions="GRANT ALL PRIVILEGES ON DATABASE ${REDMINE_DB_NAME} to ${REDMINE_DB_USER};"
    echo $fixGitlabPermissions | gosu postgres postgres --single -jE

    echo
  fi

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
      *.sql) echo "$0: running $f"; psql --username "$SU_USER" --dbname "$DB" < "$f" && echo ;;
      *)     echo "$0: ignoring $f" ;;
    esac
    echo
  done

  gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop

  { echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA"/pg_hba.conf
else
  echo "not creating database"


  userSql="ALTER USER $SU_USER WITH SUPERUSER PASSWORD '$SU_PASS';"
  echo $userSql | gosu postgres postgres --single -jE
  echo

  if [ "$GITLAB_DB_USER" ]; then
    echo "alter user with password $GILAB_DB_PASS"
    gitlabSql="ALTER USER $GITLAB_DB_USER WITH LOGIN CREATEDB PASSWORD '$GITLAB_DB_PASS';"
    echo $gitlabSql | gosu postgres postgres --single -jE
  fi

  if [ "REDMINE_DB_USER" ]; then
    redmineSql="ALTER USER $REDMINE_DB_USER WITH LOGIN CREATEDB PASSWORD '$REDMINE_DB_PASS';"
    echo $redmineSql | gosu postgres postgres --single -jE
  fi
fi

exec gosu postgres "$@"
