# Devops challenge

## Introduction

Infrastructure is defined as code with Terraform. 

The main purpose is create a new GKE cluster and deploy a dummy app.

The app needs a dynamic value generated each time a deployment happens


## Requirements

1. Fix terraform & helm configuration errors
    We have improved the Terraform code by separating all the variables into the variables file, eliminating hardcoded data. We've set up workspaces for development, pre-production, and production, requiring one of them to be initiated for execution. These workspaces have been configured with some examples in the variables file and in the main.tf code. We've also extracted the application's Terraform code into a module to be invoked from the main script and renamed files to adhere properly to Terraform conventions. Additionally, we have added comments for better understanding and maintainability
2. Propose improvements in the code
    As improvements, as we mentioned in section one, we've proposed using different workspace environments to separate variables. This includes networks to isolate environments, permissions, etc. Regarding code enhancements, I would add restrictions of least privilege for the roles of all resources and create isolated accounts to differentiate environments in a simpler way.
3. Add tests
    Checking the output of terraform validate.    Success! The configuration is valid. and checking the terraform plan output 
    random_id.suffix: Refreshing state... [id=ks4QwQ]
data.google_compute_network.network: Reading...
data.google_client_config.default: Reading...
data.google_client_config.default: Read complete after 0s [id=projects/testidovenmanu/regions/europe-west1/zones/]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform planned the following actions, but then encountered a problem:

  # google_compute_subnetwork.nodes will be created
  + resource "google_compute_subnetwork" "nodes" {
      + creation_timestamp         = (known after apply)
      + external_ipv6_prefix       = (known after apply)
      + fingerprint                = (known after apply)
      + gateway_address            = (known after apply)
      + id                         = (known after apply)
      + ip_cidr_range              = "10.0.0.0/24"
      + ipv6_cidr_range            = (known after apply)
      + name                       = "nodes"
      + network                    = "data.google_compute_network.network.self_link"
      + private_ip_google_access   = (known after apply)
      + private_ipv6_google_access = (known after apply)
      + project                    = (known after apply)
      + purpose                    = (known after apply)
      + region                     = (known after apply)
      + secondary_ip_range         = (known after apply)
      + self_link                  = (known after apply)
      + stack_type                 = (known after apply)
    }

  # google_container_cluster.cluster will be created
  + resource "google_container_cluster" "cluster" {
      + cluster_ipv4_cidr           = (known after apply)
      + datapath_provider           = (known after apply)
      + default_max_pods_per_node   = (known after apply)
      + description                 = "Managed by Terraform"
      + enable_binary_authorization = false
      + enable_intranode_visibility = (known after apply)
      + enable_kubernetes_alpha     = false
      + enable_l4_ilb_subsetting    = false
      + enable_legacy_abac          = false
      + enable_shielded_nodes       = true
      + endpoint                    = (known after apply)
      + id                          = (known after apply)
      + initial_node_count          = 1
      + label_fingerprint           = (known after apply)
      + location                    = "europe-west1"
      + logging_service             = (known after apply)
      + master_version              = (known after apply)
      + monitoring_service          = (known after apply)
      + name                        = "develop"
      + network                     = "data.google_compute_network.network.self_link"
      + networking_mode             = "VPC_NATIVE"
      + node_locations              = (known after apply)
      + node_version                = (known after apply)
      + operation                   = (known after apply)
      + private_ipv6_google_access  = (known after apply)
      + project                     = "testidovenmanu"
      + remove_default_node_pool    = true
      + resource_labels             = {
          + "terraform" = "managed"
        }
      + self_link                   = (known after apply)
      + services_ipv4_cidr          = (known after apply)
      + subnetwork                  = (known after apply)
      + tpu_ipv4_cidr_block         = (known after apply)

      + addons_config {
          + http_load_balancing {
              + disabled = false
            }
        }

      + ip_allocation_policy {
          + cluster_ipv4_cidr_block       = (known after apply)
          + cluster_secondary_range_name  = "10.0.1.0/24"
          + services_ipv4_cidr_block      = (known after apply)
          + services_secondary_range_name = "10.0.2.0/24"
        }

      + maintenance_policy {
          + daily_maintenance_window {
              + duration   = (known after apply)
              + start_time = "09:00"
            }
        }

      + private_cluster_config {
          + enable_private_nodes   = true
          + master_ipv4_cidr_block = "10.14.64.0/28"
          + peering_name           = (known after apply)
          + private_endpoint       = (known after apply)
          + public_endpoint        = (known after apply)
        }

      + release_channel {
          + channel = "UNSPECIFIED"
        }
        ..
        ..
        ..
        .
        To test the code in Terraform, we will use pytest with tftest. In the tests directory, there is an example code to test in the app module that the variables have the expected values.
         pytest test.py 
        ============================================================ test session starts =============================================================
        platform linux -- Python 3.10.6, pytest-6.2.5, py-1.10.0, pluggy-0.13.0
        rootdir: /home/manu/Documentos/proyectos/test/devops-challenge/terraform/test
        collected 1 item                                                                                                                             

        test.py 
        .                                                                                                                              [100%]

        ============================================================= 1 passed in 4.11s ==============================================================

## Bonus

4. Instead of only one app, there are many in different repositories.
How would you orchestrate the deployment?

I would use a repository orchestrator like https://gerrit.googlesource.com/git-repo to consolidate them into one and manage the repositories.
---

Submit your solution either via Github or Gitlab

