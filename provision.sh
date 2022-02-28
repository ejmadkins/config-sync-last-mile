#!/bin/bash

set -o errexit -o nounset -o pipefail

# get GCP Project ID and Git repo URL from user
get_inputs () {
  echo Enter Project ID:
  read project
  echo Enter Git Repo URL:
  read git_repo
}

# enable ACM as a hub feature
enable_acm () {
  terraform -chdir=terraform/global init
  terraform -chdir=terraform/global apply -var "project=${project}" -auto-approve
}

# provision clusters
create_cluster () {
  get_inputs
  enable_acm
  terraform -chdir=terraform/clusters init
  terraform -chdir=terraform/clusters apply -var "project=${project}" -var "sync_repo=${git_repo}" -auto-approve
  gcloud container clusters get-credentials ${cluster} --region europe-west2 --project ${project}
}

# delete clusters
destroy_cluster () {
  get_inputs
  terraform -chdir=terraform/clusters init
  terraform -chdir=terraform/clusters destroy  -var "project=${project}" -var "sync_repo=${git_repo}" -auto-approve
}

while getopts cdh flag
do
    case "${flag}" in
        c) create_cluster ;;
        d) destroy_cluster ;;
    esac
done