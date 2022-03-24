output "gcp_network_id" {
  value = [for name, network in google_compute_network.vpc_network : network.id]
}

output "gcp_web_subnet_id" {
  value = [for name, subnet in google_compute_subnetwork.subnet1 : subnet.id]
}

output "gcp_db_subnet_id" {
  value = [for name, subnet in google_compute_subnetwork.subnet2 : subnet.id]
}