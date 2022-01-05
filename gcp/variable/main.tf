provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

data "google_compute_network" "mynetwork" {
  name = "ansible-testing"
}

data "google_compute_regions" "current" {}
data "google_compute_zones" "availablityzones" {}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terraform STARTS : $(date) > output.log"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    interpreter = ["python3", "-c"]
    command     = "print('Hello World!!')"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command = "echo Terraform ENDS : $(date) >> output.log"
  }
}

#locals {
#  count           = length(data.google_compute_regions.current.names)
# region          = data.google_compute_regions.current.names[count.index]
#  Number_of_AZs   = data.google_compute_regions.current.names.count
#  Region_fullname = data.google_compute_regions.current.names.region
#  Number_of_AZs     = length(data.google_compute_zones.name)
#  Names_of_AZs      = join(",", data.google_compute_zones.name)
#  Full_project_name = "${var.gcp_project} running in ${local.Region_fullname}"
#}

#locals {
#  Region_Info    = "This Resource is in ${data.aws_region.current.description} consist of ${length(data.aws_availability_zones.available.names)} AZs"
#  Region_Info_v2 = "This Resource is in ${local.Region_fullname} consist of ${local.Number_of_AZs} AZs"
#}