variable "gcp_region" {
  description = "Region where resources needs to be deployed"
  default     = "europe-north1"
  type        = string
}

variable "gcp_project" {
  description = "Project in which resources needs to be deployed"
  default     = "ansible-327612"
  type        = string
}