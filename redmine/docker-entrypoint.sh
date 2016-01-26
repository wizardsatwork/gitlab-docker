#!/bin/bash
set -e

source /ENV.sh

case "$1" in
  rails|rake|passenger)

    if [ "$1" != 'rake' -a -z "$REDMINE_NO_DB_MIGRATE" ]; then
      gosu redmine rake db:migrate
    fi

    chown -R ${REDMINE_USER}:${REDMINE_GROUP} files log public/plugin_assets

    # remove PID file to enable restarting the container
    rm -f /usr/src/redmine/tmp/pids/server.pid

    if [ "$1" = 'passenger' ]; then
      # Don't fear the reaper.
      set -- tini -- "$@"
    fi

    set -- gosu redmine "$@"
    ;;
esac

exec "$@"
