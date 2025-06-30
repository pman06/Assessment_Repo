locals {

  zones = slice(data.google_compute_zones.available.names, 0, 1)

  # we will pick the latest k8s version
  master_version = data.google_container_engine_versions.main.valid_master_versions[0]
}

data "google_compute_zones" "available" {
  region = var.region
  status = "UP"
}

data "google_container_engine_versions" "main" {
  location       = var.region
  version_prefix = "${var.k8s_version}."
}


resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  node_locations     = local.zones
  min_master_version = local.master_version
  initial_node_count = 1
  deletion_protection = false 

  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_size_gb = 10
    labels = {
      env = "dev"
    }
    tags = ["web", "dev"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}