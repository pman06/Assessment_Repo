terraform {
  backend "gcs" {
    }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.0.0"
    }
  }
}

provider "google" {
  project = var.project
  credentials = var.gcp_credentials
  region  = var.region
}


module "vpc_with_subnets" {
  source = "./modules/vpc"

  vpc_name    = var.cluster_name
  subnet_name = var.cluster_name

  region = var.region

  cidrBlock = var.cidrBlock
}

module "gke_with_node_group" {

  source = "./modules/gke"

  cluster_name = var.cluster_name
  k8s_version  = var.k8s_version
  region       = var.region
  nodepools    = var.nodepools
  network      = module.vpc_with_subnets.vpc_self_link
  subnetwork   = module.vpc_with_subnets.subnet_self_link
}
