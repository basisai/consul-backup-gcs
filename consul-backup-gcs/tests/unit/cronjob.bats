#!/usr/bin/env bats

load _helpers

############################################################
# GCS Key
############################################################
@test "cronJob: GCS Key Volume is present" {
  cd `chart_dir`

  local actual=$(helm template \
      --show-only templates/cronjob.yaml  \
      --set 'gcs.bucket=foobar' \
      .  | tee /dev/stderr |
      yq -r '.spec.jobTemplate.spec.template.spec.volumes | length' | tee /dev/stderr)

  [ "${actual}" = '1' ]

  local actual=$(helm template \
      --show-only templates/cronjob.yaml  \
      --set 'gcs.bucket=foobar' \
      --set 'gcs.serviceAccountKey=foobar' \
      . | tee /dev/stderr |
      yq -r '.spec.jobTemplate.spec.template.spec.volumes | length' | tee /dev/stderr)

  [ "${actual}" = '2' ]
}

@test "cronJob: GCS Key Volume is mounted" {
  cd `chart_dir`

  local actual=$(helm template \
      --show-only templates/cronjob.yaml  \
      --set 'gcs.bucket=foobar' \
      .  | tee /dev/stderr |
      yq -r '.spec.jobTemplate.spec.template.spec.containers[0].volumeMounts | length' | tee /dev/stderr)

  [ "${actual}" = '1' ]

  local actual=$(helm template \
      --show-only templates/cronjob.yaml  \
      --set 'gcs.bucket=foobar' \
      --set 'gcs.serviceAccountKey=foobar' \
      . | tee /dev/stderr |
      yq -r '.spec.jobTemplate.spec.template.spec.containers[0].volumeMounts | length' | tee /dev/stderr)

  [ "${actual}" = '2' ]
}
