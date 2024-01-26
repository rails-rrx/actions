#!/usr/bin/env bash
set -e

if [[ "$DB_HOST" == '' ]] || [[ "$DB_PORT" == '' ]]; then
  echo 'No database configured'
else
  echo DB_HOST is $DB_HOST
  echo DB_PORT is $DB_PORT

  until nc -z $DB_HOST $DB_PORT; do
   echo 'Waiting for database...'
   sleep 1
  done
  echo "Database is up and running!"
fi
