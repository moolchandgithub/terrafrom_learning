output "my_gcp_network_id" {
  value = module.my_vpc_ansible.gcp_network_id
}

output "my_web_gcp_subnet_id" {
  value = module.my_vpc_ansible.gcp_web_subnet_id
}

output "my_db_gcp_subnet_id" {
  value = module.my_vpc_ansible.gcp_db_subnet_id
}