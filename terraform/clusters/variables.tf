variable "project" {
  type        = string
  description = "the GCP project where the cluster will be created"
  default     = "ejmadkins-krm-0929"
}

variable "gke_name" {
  type        = string
  description = "the name of the East GKE cluster."
  default     = "cluster-krm-demo"
}

variable "zone" {
  type        = string
  description = "the zone for the East GKE cluster."
  default     = "europe-west1-b"
}

variable "region" {
  type        = string
  description = "the region for the East GKE cluster."
  default     = "europe-west1"
}

variable "sync_repo" {
  type        = string
  description = "git URL for the repo which will be sync'ed into the cluster via Config Management"
  default     = "https://github.com/ejmadkins/config-sync-last-mile.git"
}

variable "policy_dir" {
  type        = string
  description = "the root directory in the repo branch that contains the resources."
  default     = "config/"
}