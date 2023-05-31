# Project ID
variable "project_id" {
  description = "ID of the project"
  type        = string
  default     = "testidovenmanu"
}

# Region
variable "region" {
  description = "The region where resources should be created"
  type        = string
  default     = "europe-west1"
}

# Network Name
variable "network_name" {
  description = "Name of the network"
  type        = string
  default     = "default"
}

# Subnets
variable "subnets" {
  description = "Map of subnets"
  type        = map(map(string))
  default = {
    dev = {
      nodes    = "10.0.0.0/24"
      pods     = "10.0.1.0/24"
      services = "10.0.2.0/24"
    }
    pre = {
      nodes    = "10.1.0.0/24"
      pods     = "10.1.1.0/24"
      services = "10.1.2.0/24"
    }
    pro = {
      nodes    = "10.2.0.0/24"
      pods     = "10.2.1.0/24"
      services = "10.2.2.0/24"
    }
  }
}

# Cluster Name
variable "cluster_name" {
  description = "Name of the cluster"
  type        = map(string)
  default = {
    dev = "develop"
    pre = "preproduction"
    pro = "production"
  }
}

# Node Pools
variable "pools_map" {
  description = "Map of node pools"
  type        = map(any)
  default = {
    default = {
      machine_type = "e2-standard-8"
      disk_size    = "100"
      labels = {
        cloud  = "gcp"
        region = "eu"
        pool   = "default"
      }
      tags        = {}
      preemptible = true
      zones       = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
      autoscaling = {
        min = 1
        max = 3
      }
    }
  }
}

# Kubernetes Namespaces
variable "k8s_namespaces" {
  description = "Map of Kubernetes namespaces"
  type        = map(any)
  default = {
    apps = {
      labels      = {}
      annotations = {}
    }
    cert-manager = {
      labels      = {}
      annotations = {}
    }
  }
}

# Masters CIDR
variable "masters_cidr" {
  description = "CIDR block for the masters"
  type        = map(string)
  default = {
    dev = "10.14.64.0/28"
    pre = "11.14.64.0/28"
    pro = "12.14.64.0/28"
  }
}

# Timezone
variable "timezone" {
  description = "Timezone of the cluster"
  type        = string
  default     = "Europe/Madrid"
}

# Chart Path
variable "chart_path" {
  description = "Path to the Helm chart for the application"
  type        = string
  default     = "../app1"
}

# Chart Name
variable "chart_name" {
  description = "Name for the Helm chart for the application"
  type        = string
  default     = "app1"
}

# Random ID Byte Length
variable "random_id_byte_length" {
  description = "The byte length for the random ID generation"
  type        = number
  default     = 4
}

# Subnetwork Name
variable "subnetwork_name" {
  description = "The name of the subnetwork"
  type        = string
  default     = "nodes"
}


# Release Channel
variable "release_channel" {
  description = "The release channel for the Google Kubernetes Engine cluster"
  type        = string
  default     = "UNSPECIFIED"
}

# Addons HTTP Load Balancing Disabled
variable "addons_http_load_balancing_disabled" {
  description = "Flag to disable the HTTP load balancing addon"
  type        = bool
  default     = false
}

# Private Cluster Endpoint Enabled
variable "private_cluster_endpoint_enabled" {
  description = "Flag to enable the private cluster endpoint"
  type        = bool
  default     = false
}

# Private Cluster Nodes Enabled
variable "private_cluster_nodes_enabled" {
  description = "Flag to enable private nodes in the cluster"
  type        = bool
  default     = true
}
variable "start_time" {
  description = "time to start"
  type        = string
  default     = "09:00"
}