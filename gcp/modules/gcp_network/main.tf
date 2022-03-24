locals {
  yaml_map = merge(
    [
      for yaml in fileset("${path.root}/network_yaml", "net-*.yaml") :
      yamldecode(file("${path.root}/network_yaml/${yaml}"))
    ]...
  )
}

resource "google_compute_network" "vpc_network" {
  for_each                = local.yaml_map != null ? { for k, v in local.yaml_map : k => v } : tomap()
  project                 = var.gcp_project
  name                    = each.value.network.name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet1" {
  for_each      = local.yaml_map != null ? { for k, v in local.yaml_map : k => v } : tomap()
  name          = each.value.subnet[0].name
  ip_cidr_range = each.value.subnet[0].cidr
  region        = var.gcp_region
  network       = each.value.network.name
  depends_on = [
    google_compute_network.vpc_network
  ]
}

resource "google_compute_subnetwork" "subnet2" {
  for_each      = local.yaml_map != null ? { for k, v in local.yaml_map : k => v } : tomap()
  name          = each.value.subnet[1].name
  ip_cidr_range = each.value.subnet[1].cidr
  region        = var.gcp_region
  network       = each.value.network.name
  depends_on = [
    google_compute_subnetwork.subnet1
  ]
}