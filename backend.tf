terraform {
  required_version = ">= 1.12.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "8.12.0"
    }
  }
  backend "oci" {}
}
