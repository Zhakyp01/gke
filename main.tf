############### Provider Start ######################

provider "google" {
  credentials = var.cred
  # project     = "student-project-379814"
  region = var.region
}
############### Provider End ######################
############### Backend Start ######################

terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0, < 5.0"
    }
  }
}

############### Backend End #####################
