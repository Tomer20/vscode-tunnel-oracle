terraform {
  required_version = ">= 1.12.2"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "9.11.0"
    }
  }
  backend "oci" {}
}
