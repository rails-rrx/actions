#!/usr/bin/env bash
set -ex -o pipefail

readonly script_dir=$(dirname $0)
readonly host='liaisun-dev.cls80eciebmf.us-west-2.rds.amazonaws.com'
readonly port='3306'
readonly database='liaisun'
readonly username='liaisun_api'
readonly pem_file="${script_dir}/global.pem"

readonly token=$(aws \
  rds generate-db-auth-token \
  --hostname ${host} \
  --port ${port} \
  --region us-west-2 \
  --username ${username}
)

if ! [[ -f "${pem_file}" ]]; then
  curl https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem > "${pem_file}"
  echo 'Downloaded PEM file'
  sha256sum "${pem_file}"
  # cat "${pem_file}"
fi

mysql \
-v \
--host=${host} \
--port=${port} \
--enable-cleartext-plugin \
--ssl-ca="${pem_file}" \
--user=${username} \
--password="${token}" \
-e 'SELECT 1' \
${database}
