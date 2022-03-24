terraform {
  backend "gcs" {
    bucket = "ansible-327612-infra-europe-north1-tf-state" # replace with the proper bucket name
    prefix = "gcp-infra"                                   # keep the name consistent with the name of repository/folder
  }
}