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

############################################################
# TLS
############################################################
@test "configMap: TLS is enabled" {
  cd `chart_dir`

  local config=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      .  | tee /dev/stderr |
      yq -r '.data."vars.yml"' | tee /dev/stderr)

  local actual=$(echo "${config}" |
      yq -r '.consul_environment.CONSUL_HTTP_SSL' | tee /dev/stderr)
  [ "${actual}" = 'false' ]

  local config=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      --set 'consul.tls.enabled=true' \
      .  | tee /dev/stderr |
      yq -r '.data."vars.yml"' | tee /dev/stderr)

  local actual=$(echo "${config}" |
     yq -r '.consul_environment.CONSUL_HTTP_SSL' | tee /dev/stderr)
  [ "${actual}" = 'true' ]
}

@test "configMap: CA Certificate is populated" {
  cd `chart_dir`

  local actual=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      .  | tee /dev/stderr |
      yq -r '.data."server.pem"' | tee /dev/stderr)

  [ "${actual}" = 'null' ]

  local actual=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      --set 'consul.tls.cacert=foobar' \
      .  | tee /dev/stderr |
      yq -r '.data."server.pem"' | tee /dev/stderr)

  [ "${actual}" = 'foobar' ]
}

@test "configMap: CA Certificate is used" {
  cd `chart_dir`

  local config=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      .  | tee /dev/stderr |
      yq -r '.data."vars.yml"' | tee /dev/stderr)

  local actual=$(echo "${config}" |
      yq -r '.consul_environment.CONSUL_CACERT' | tee /dev/stderr)
  [ "${actual}" = 'null' ]

  local config=$(helm template \
      --show-only templates/configmap.yaml  \
      --set 'gcs.bucket=foobar' \
      --set 'consul.tls.enabled=true' \
      --set 'consul.tls.cacert=foobar' \
      .  | tee /dev/stderr |
      yq -r '.data."vars.yml"' | tee /dev/stderr)

  local actual=$(echo "${config}" |
      yq -r '.consul_environment.CONSUL_CACERT' | tee /dev/stderr)
  [ "${actual}" = '/config/server.pem' ]
}
