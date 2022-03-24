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

module "my_vpc_ansible" {
  source          = "./modules/gcp_network"
}