variable "state_bucket" {
  description = "Deployment project"
  type        = string
  default     = "backend-bucket-test-app"
}

variable "region" {
  description = "Deployment region"
  type        = string
}


# variable "zone" {
#   description = "Deployment zone"
#   type        = string
# }

variable "project" {
  description = "Deployment project"
  type        = string
}


variable "cluster_name" {
  type        = string
  description = "vpc, subnet and gke cluster name"
}

variable "k8s_version" {
  type        = string
  description = "kubernetes version"
  default     = "1.29"
}

variable "cidrBlock" {
  type        = string
  description = "The cidr block for subnet"
  default     = "10.1.0.0/16"
}

variable "gcp_credentials" {
  type = string
  sensitive = true
  description = "Google Cloud service account credentials"
}

variable "nodepools" {
  description = "Nodepools for the Kubernetes cluster"
  type = map(object({
    name         = string
    node_count   = number
    node_labels  = map(any)
    machine_type = string
  }))
  default = {
    worker = {
      name         = "worker"
      node_labels  = { "worker-name" = "worker" }
      machine_type = "n1-standard-1"
      node_count   = 1
    }
  }
}