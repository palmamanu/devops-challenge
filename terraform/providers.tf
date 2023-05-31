terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.49.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.8.0"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}

# Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Google Cloud client config data
data "google_client_config" "default" {}

# Kubernetes provider
provider "kubernetes" {
  host                   = google_container_cluster.cluster.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
}

# Helm provider
provider "helm" {
  kubernetes {
    host                   = google_container_cluster.cluster.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  }
}

# HTTP provider
provider "http" {}
