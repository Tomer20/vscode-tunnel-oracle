terraform {
  required_version = ">= 1.12.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "7.12.0"
    }
  }
  backend "oci" {}
}
