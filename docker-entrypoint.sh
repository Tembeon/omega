#!/bin/sh
set -e
PGDATA="/app/data/db/postgres"
mkdir -p "$PGDATA"
if [ ! -d "$PGDATA/base" ]; then
  initdb -D "$PGDATA"
fi
pg_ctl -D "$PGDATA" -o "-k /tmp" -w start
/app/bin/bot
