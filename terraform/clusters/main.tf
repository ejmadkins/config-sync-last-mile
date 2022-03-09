module "gke_east" {

  source   = "../modules/gke_cluster"
  project  = var.project
  gke_name = var.gke_name
  zone     = var.zone
  region   = var.region
  sync_repo   = var.sync_repo
  policy_dir  = var.policy_dir
}

module "image-serve-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "image-serve"
  namespace  = "tenant-a"
  project_id = var.project
  roles      = ["roles/storage.admin"]
}