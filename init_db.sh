#!/bin/bash
pg_ctl status --silent > /dev/null 2>&1
DB_RUNNING=$?
if [ $DB_RUNNING -eq 0 ]; then
  echo "DB already running."
else
  echo "Starting db..."
  pg_ctl start --log pg.log
fi

psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'postgres'" | grep -q 1
DB_EXISTS=$?
if [ $DB_EXISTS -eq 0 ]; then
  echo "DB already exists."
else
  echo "Creating postgres db..."
  createdb postgres
  psql -d postgres -c "CREATE ROLE postgres LOGIN SUPERUSER"
fi
