





# Define resources
terraform {
  backend "gcs" {
    bucket = "testidovenmanu"
    prefix = "testidovenmanu"
    # credentials = "ruta-al-archivo-de-credenciales"
  }
}

# Generate a random ID
resource "random_id" "suffix" {
  byte_length = var.random_id_byte_length
}

# Create a Google Compute Engine subnetwork
resource "google_compute_subnetwork" "nodes" {
  ip_cidr_range = var.subnets[terraform.workspace][var.subnetwork_name]
  name          = var.subnetwork_name
  network       = data.google_compute_network.network.self_link
}

# Get an existing Google Compute Engine network
data "google_compute_network" "network" {
  name    = var.network_name
  project = var.project_id
}

# Create a Google Kubernetes Engine cluster
resource "google_container_cluster" "cluster" {
  name                     = var.cluster_name[terraform.workspace]
  description              = "Managed by Terraform"
  remove_default_node_pool = true
  networking_mode          = "VPC_NATIVE"
  location                 = var.region
  network                  = data.google_compute_network.network.self_link
  subnetwork               = google_compute_subnetwork.nodes.self_link
  project                  = var.project_id
  initial_node_count       = 1
  resource_labels = {
    "terraform" = "managed"
  }

  release_channel {
    channel = var.release_channel
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.subnets[terraform.workspace]["pods"]
    services_secondary_range_name = var.subnets[terraform.workspace]["services"]
  }

  addons_config {
    http_load_balancing {
      disabled = var.addons_http_load_balancing_disabled
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.start_time
    }
  }

  private_cluster_config {
    enable_private_endpoint = var.private_cluster_endpoint_enabled
    enable_private_nodes    = var.private_cluster_nodes_enabled
    master_ipv4_cidr_block  = var.masters_cidr[terraform.workspace]
  }
}

# Create a node pool in the Google Kubernetes Engine cluster
resource "google_container_node_pool" "pool" {
  for_each = var.pools_map

  cluster            = "google_container_cluster.cluster.name-${terraform.workspace}"
  location           = google_container_cluster.cluster.location
  project            = var.project_id
  name_prefix        = each.key
  node_locations     = each.value.zones
  initial_node_count = 1

  node_config {
    disk_type    = "pd-standard"
    disk_size_gb = each.value.disk_size
    image_type   = "cos_containerd"
    labels       = each.value.labels
    machine_type = each.value.machine_type
    preemptible  = each.value.preemptible
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    metadata = {
      "disable-legacy-endpoints" = true
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    max_node_count  = each.value.autoscaling.max
    min_node_count  = each.value.autoscaling.min
    location_policy = "ANY"
  }

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  upgrade_settings {
    max_surge       = 2
    max_unavailable = 0
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [initial_node_count]
  }
}

# Create Kubernetes namespaces
resource "kubernetes_namespace" "namespace" {
  depends_on = [
    google_container_cluster.cluster,
    google_compute_subnetwork.nodes,
  ]

  for_each = var.k8s_namespaces

  metadata {
    name        = each.key
    labels      = each.value.labels
    annotations = each.value.annotations
  }
}

# Create the application module
module "app_module" {
  depends_on = [
    google_container_cluster.cluster,
  ]

  source     = "./modules/app_module"
  timezone   = var.timezone
  chart_path = var.chart_path
  chart_name = var.chart_name
}
