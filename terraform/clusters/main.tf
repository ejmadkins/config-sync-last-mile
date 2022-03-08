module "gke_east" {

  source   = "../modules/gke_cluster"
  project  = var.project
  gke_name = var.gke_name
  zone     = var.zone
  region   = var.region
  sync_repo   = var.sync_repo
  policy_dir  = var.policy_dir

  network_policy {
    enabled  = var.enable_dataplane_v2 ? false : true
    provider = var.enable_dataplane_v2 ? "PROVIDER_UNSPECIFIED" : "CALICO"
  }
  datapath_provider = var.enable_dataplane_v2 ? "ADVANCED_DATAPATH" : "DATAPATH_PROVIDER_UNSPECIFIED"
}