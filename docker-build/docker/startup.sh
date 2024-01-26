#!/usr/bin/env bash
set -ex

if [[ -f config/database.yml ]]; then
  # Wait for DB services
  # docker/wait-for-services.sh
  # Prepare DB (Migrate - If not? Create db & Migrate)
  docker/prepare-db.sh
fi

# Start Application
bundle exec puma -p 3000 -S .puma -C config/puma.rb
