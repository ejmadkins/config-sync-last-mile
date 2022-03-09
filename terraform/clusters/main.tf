module "gke_east" {

  source   = "../modules/gke_cluster"
  project  = var.project
  gke_name = var.gke_name
  zone     = var.zone
  region   = var.region
  sync_repo   = var.sync_repo
  policy_dir  = var.policy_dir
}