terraform {
  required_version = ">= 1.12.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "8.3.0"
    }
  }
  backend "oci" {}
}
