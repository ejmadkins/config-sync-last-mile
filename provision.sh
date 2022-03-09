#!/bin/bash

set -o errexit -o nounset -o pipefail

# get GCP Project ID and Git repo URL from user
get_inputs () {
  echo Enter Project ID:
  read project
  echo Enter RootSync Git Repo URL:
  read rootsync_repo
  echo Enter RepoSync Git Repo URL:
  read reposync_repo
}

# update project
update_project () {
  sed -i "s/PROJECT-INSERT/${project}/g" config/base/kcc/configconnector.yaml
  sed -i "s/PROJECT-INSERT/${project}/g" sample-app/k8s/deployment.yaml
  sed -i "s/PROJECT-INSERT/${project}/g" sample-app/skaffold.yaml
}

# update project
update_reposync () {
  sed -i "s/TENANT-REPO/${reposync_repo}/g" config/tenants/tenant-a/configconnector.yaml
}

git_push () {
  git commit -am "update project specific items"
  git push
}

# enable ACM as a hub feature
enable_acm () {
  terraform -chdir=terraform/global init
  terraform -chdir=terraform/global apply -var "project=${project}" -auto-approve
}

# provision clusters
create_cluster () {
  get_inputs
  update_project
  enable_acm
  terraform -chdir=terraform/clusters init
  terraform -chdir=terraform/clusters apply -var "project=${project}" -var "sync_repo=${rootsync_repo}" -auto-approve
  gcloud container clusters get-credentials ${cluster} --region europe-west2 --project ${project}
}

# delete clusters
destroy_cluster () {
  get_inputs
  terraform -chdir=terraform/clusters init
  terraform -chdir=terraform/clusters destroy  -var "project=${project}" -var "sync_repo=${rootsync_repo}" -auto-approve
}

while getopts cdh flag
do
    case "${flag}" in
        c) create_cluster ;;
        d) destroy_cluster ;;
    esac
done