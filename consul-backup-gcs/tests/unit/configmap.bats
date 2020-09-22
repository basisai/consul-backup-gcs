#!/usr/bin/env bats

load _helpers

############################################################
# GCS Key
############################################################
@test "configMap: configured to use GCS Key" {
  cd `chart_dir`

  local config=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      .  | tee /dev/stderr |
      yq -r '.data."vars.yml"' | tee /dev/stderr)

  local actual=$(echo "${config}" |
      yq -r '.service_account_key' | tee /dev/stderr)
  [ "${actual}" = 'null' ]

  local config=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      --set 'gcs.serviceAccountKey=foobar' \
      .  | tee /dev/stderr |
      yq -r '.data."vars.yml"' | tee /dev/stderr)

  local actual=$(echo "${config}" |
      yq -r '.service_account_key' | tee /dev/stderr)
  [ "${actual}" = '/gcs/gcs.json' ]
}
