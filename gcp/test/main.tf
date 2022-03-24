terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.0"
    }
  }
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

# locals {
#   yaml_map = merge(
#     [
#       for yaml in fileset("../network_yaml", "net-*.yaml") :
#       yamldecode(file("../network_yaml/${yaml}"))
#     ]...
#   )
# }
locals {
  yaml_map = merge(
    [
      for yaml in fileset("../network_yaml", "net-*.yaml") :
      yamldecode(file("../network_yaml/${yaml}"))
    ]...
  )

#   sub_list = [ for key, value in local.yaml_map : [
#       for sub in try(value.subnet,[]) : {
#           subnet = sub
#       }
#   ]
#   ]
#   sub_map = { for sub in local.sub_list :
#     keys(sub)[0] => values(sub)[0]
#   }
}

resource "google_compute_network" "vpc_network" {
  for_each = local.yaml_map != null ? { for k, v in local.yaml_map : k => v } : tomap()
  project                 = var.gcp_project
  name                    = each.value.network.name
  auto_create_subnetworks = false
  mtu                     = 1460
}

# resource "google_compute_subnetwork" "subnet" {
#   for_each = local.sub_list != null ? { for k, v in local.sub_list : k => v } : tomap()
#   name          = each.value.subnet[0].subnet.name
#   ip_cidr_range = each.value.subnet[0].subnet.cidr
#   region        = var.gcp_region
#   network       = google_compute_network.vpc_network[each.key].id
# }

resource "google_compute_subnetwork" "subnet1" {
  for_each = local.yaml_map != null ? { for k, v in local.yaml_map : k => v } : tomap()
  name          = each.value.subnet[0].name
  ip_cidr_range = each.value.subnet[0].cidr
  region        = var.gcp_region
  network       = each.value.network.name
  depends_on = [
    google_compute_network.vpc_network
  ]
}

resource "google_compute_subnetwork" "subnet2" {
  for_each = local.yaml_map != null ? { for k, v in local.yaml_map : k => v } : tomap()
  name          = each.value.subnet[1].name
  ip_cidr_range = each.value.subnet[1].cidr
  region        = var.gcp_region
  network       = each.value.network.name
  depends_on = [
    google_compute_subnetwork.subnet1
  ]
}

# output "network" {
#   description = "Network Name."
#   value = [for name, network in google_compute_network.vpc_network : network.name]
# }

# output "subnet1" {
#   description = "Subnet Name."
#   value = [for name, subnet in local.sub_list : subnet]
# }

# output "subnet2" {
#   description = "Subnet Name."
#   value = [
#     for k, v in local.yaml_map :
#         v.subnet[1].name
#   ]
# }