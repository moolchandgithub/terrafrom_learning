terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.0"
    }
  }
}

# Google Cloud infrastructure
provider "google" {
  credentials = file(pathexpand("~/.config/gcloud/ansible-327612-a45fbb9d7341.json"))
  region      = var.gcp_region
  project     = var.gcp_project
}

resource "google_storage_bucket" "bucket" {
  name          = "bucket-${var.gcp_project}"
  location      = var.gcp_region
  force_destroy = true
  project       = var.gcp_project
}

resource "google_storage_bucket_object" "post_script" {
  name    = "install-web.sh"
  bucket  = google_storage_bucket.bucket.name
  source = "install-web.sh"
}

resource "google_compute_firewall" "web" {
  description = "Web Server Firewall Rule"
  project     = var.gcp_project
  name        = "web-server-fw"
  network     = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  target_tags   = ["web-server"]
  source_ranges = ["0.0.0.0/0"]
}

data "google_compute_default_service_account" "default" {
  project = var.gcp_project
}

resource "google_compute_instance" "web_server" {
  name         = "web-server"
  project      = var.gcp_project
  zone         = "${var.gcp_region}-b"
  machine_type = var.machine_size

  tags = ["web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    email = data.google_compute_default_service_account.default.email
    #   scopes = ["cloud-platform"]
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/trace.append"]
  }

  metadata = {
    "startup-script-url" = "gs://${google_storage_bucket.bucket.name}/install-web.sh"
  }
}

