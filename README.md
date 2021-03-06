# Consul Backup

This repository contains the Docker image for running a job to backup
[snapshots](https://www.consul.io/docs/commands/snapshot.html) of Consul and save it to
GCS.

This repository also contains a Helm chart for deploying a cron job on a Kubernetes cluster.

## Docker Image

The Docker image is built and published automatically to
[`basisai/consul-backup-gcs`](https://hub.docker.com/r/basisai/consul-backup-gcs).

## Requirements

To use the Helm Chart, you need to have the following:

- A GCS Bucket for backing up to
- A Consul cluster
- Access to GCP Credentials either using GKE Workload Identity, Instance Service Account,
    or providing the key in `Values.yaml`.

You can automate most of this using our
[Terraform Module](https://github.com/basisai/terraform-modules-gcp/blob/master/modules/consul_backup).
