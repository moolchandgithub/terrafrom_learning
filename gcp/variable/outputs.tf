output "mynetwork" {
  value = data.google_compute_network.mynetwork.id
}

output "zones" {
  value = data.google_compute_zones.availablityzones
}

output "region" {
  value = data.google_compute_regions.current
}

output "python" {
  value = null_resource.command2
}