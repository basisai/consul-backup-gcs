#!/usr/bin/env bats

load _helpers

@test "secret: is created only when probided service account key" {
  cd `chart_dir`

  local actual=$(helm template \
      --show-only templates/secret.yaml  \
      --set 'gcs.bucket=foobar' \
      . || echo "---" | tee /dev/stderr |
      yq -r 'length' | tee /dev/stderr)

  [ "${actual}" = '0' ]

  local actual=$(helm template \
      --show-only templates/secret.yaml  \
      --set 'gcs.bucket=foobar' \
      --set 'gcs.serviceAccountKey=foobar' \
      . | tee /dev/stderr |
      yq -r '.data."gcs.json"' | tee /dev/stderr)

  [ "${actual}" = 'Zm9vYmFy' ]
}
