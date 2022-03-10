output "bucket_name" {
  value = google_storage_bucket.bucket.name
}

output "instance_pub_ip" {
  value = google_compute_instance.web_server.network_interface.0.access_config.0.nat_ip
}