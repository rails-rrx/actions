#!/usr/bin/env bash
set -ex

function retry() {
  local -r what=$1
  local tries=$2
  local -r delay=$3

  while [[ $tries -gt 0 ]] && ! $what; do
    tries=$(( $tries - 1 ))
    echo "Retrying in $delay seconds... $tries retries left"
    sleep $delay
  done
}

function prepare() {
	bundle exec rake --trace db:prepare
}

function main() {
	echo Kick off migration for $RAILS_ENV

  if retry prepare 10 5; then
  	echo " Completed migration for sm db !"
  else
    echo " Migration failed!"
    exit 1
  fi
}

main
