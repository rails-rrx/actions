#! /bin/bash
set -x
set -e -o pipefail

readonly full_tag="${full_name}:${image_version}"

if [[ -z "${image_version}" ]] || [[ -z "${ruby_version}" ]] || [[ -z "${bundler_version}" ]]; then
  echo Missing required version info
  exit 1
fi

# GitHub outputs
echo "full_name=${full_name}" > $GITHUB_OUTPUT
echo "full_tag=${full_tag}" >> $GITHUB_OUTPUT

# Add packages for database support
case "$database" in
  mysql)
    packages="${packages} mysql-client libmysqlclient-dev"
    ;;
  mariadb)
    packages="${packages} mariadb-client libmariadb-dev libmariadb-dev-compat"
    ;;
  posgresql)
    echo "Posgresql support TODO"
    exit 1
    ;;
  none)
    ;;
  *)
    echo "Invalid database type: ${database}"
    exit 1
    ;;
esac

# Build the Docker command line
declare args=(
  "--build-arg" "RUBY_VERSION=${ruby_version}"
  "--build-arg" "BUILD_BUNDLER_VERSION=${bundler_version}"
  "--build-arg" "APT_PACKAGES=${packages}"
  "--file" "rrx.Dockerfile"
  "--tag" "${full_name}:${image_version}"
  "--metadata-file" "docker-metadata.json"
)

if $latest; then
  args+=("--tag" "${full_name}:latest")
fi

# Build the image
docker image build "${args[@]}" .
docker image ls ${full_name}
